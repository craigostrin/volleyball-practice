extends RigidBody2D

# default settings: mass 30, grav scale 10

signal hit(what)
signal touched_player
signal stuck_on_floor

export var balloon_mode := false
const BALLOON_MASS = 5
const BALLOON_GRAV_SCALE = 5
const MASS = 30
const GRAV_SCALE = 10

# for scaling the offscreen indicator
const DEFAULT_SCALE := Vector2(1.0, 1.0)
var min_scale_height := -600.0 # DEBUG: change this if screen_height gets larger
var min_scale := 0.2
var max_scale := 1.0

var radius: float
# used to cancel out `hit` signals while on floor to prevent hit-counter cheating
var is_on_floor := false

enum SoundType { LIGHT, NORMAL, HEAVY }

onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
onready var offscreen_indicator: Node2D = $OffscreenIndicator
onready var ftimer: Timer = $FloorDetector/FloorTimer


func _ready() -> void:
	offscreen_indicator.hide()
	
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_RigidBall_body_entered")
	# warning-ignore:return_value_discarded
	$FloorDetector.connect("body_entered", self, "_on_FloorDetector_body_entered_exited", [true])
	# warning-ignore:return_value_discarded
	$FloorDetector.connect("body_exited", self, "_on_FloorDetector_body_entered_exited", [false])
	# warning-ignore:return_value_discarded
	ftimer.connect("timeout", self, "_on_FloorTimer_timeout")
	
	radius = $CollisionShape2D.shape.radius
	
	if balloon_mode:
		mass = BALLOON_MASS
		gravity_scale = BALLOON_GRAV_SCALE
	else:
		mass = MASS
		gravity_scale = GRAV_SCALE


func _physics_process(_delta: float) -> void:
	# DEBUG
#	if Input.is_action_pressed("left_mouse_debug"):
#		position = get_global_mouse_position()
	
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	
	var is_offscreen := position.y < -radius
	offscreen_indicator.visible = is_offscreen
	move_offscreen_indicator()


func move_offscreen_indicator() -> void:
	# Scale the indicator based on its distance from the viewport
	var ball_height := position.y
	var scaler := max_scale - ( ball_height / min_scale_height ) * ( max_scale - min_scale )
	scaler = clamp(scaler, min_scale, max_scale)
	scale = DEFAULT_SCALE * scaler
	
	# Move the indicator along the top part of the screen
	offscreen_indicator.rotation_degrees = -rotation_degrees
	offscreen_indicator.global_position.y = 0
	offscreen_indicator.global_position.x = position.x


func _on_RigidBall_body_entered(body: Node) -> void:
	var hit_what := ""
	var sound_type := -1
	
	if body.is_in_group("player"):
		emit_signal("touched_player")
	
	if body.is_in_group("wall"):
		hit_what = "wall"
		sound_type = SoundType.LIGHT
	elif body.is_in_group("platform"):
		hit_what = "platform"
		sound_type = SoundType.NORMAL
		if linear_velocity.length_squared() >= 1200 * 1200: # 1200 velocity (1250? 1300?)
			sound_type = SoundType.HEAVY
			print("HEAVY")
			# only if player is moving forward? (would probably need to move 
			# sfx to the object being hit)
	if not hit_what == "" and not is_on_floor:
		emit_signal("hit", hit_what)
	
	# floor sound is handled by `_on_FloorDetector` so it doesn't spam while rolling
	if sound_type >= 0 and sound_type < SoundType.size():
		audio_player.play_bump(sound_type)
	
	if body.is_in_group("floor"):
		emit_signal("hit", "floor")


func _on_FloorDetector_body_entered_exited(body: Node, has_entered: bool) -> void:
	if not body.is_in_group("floor"):
		return
	
	is_on_floor = has_entered
	if has_entered:
		ftimer.start()
		audio_player.play_bump(SoundType.NORMAL)
	else:
		ftimer.stop()


func _on_FloorTimer_timeout() -> void:
	emit_signal("stuck_on_floor")
