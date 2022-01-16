extends RigidBody2D

# default settings: mass 30, grav scale 10

signal hit(what)
signal stuck_on_floor

export var balloon_mode := false
const BALLOON_MASS = 5
const BALLOON_GRAV_SCALE = 5
const MASS = 30
const GRAV_SCALE = 10

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
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	
	var is_offscreen := position.y < -radius
	offscreen_indicator.visible = is_offscreen
	move_offscreen_indicator()


func move_offscreen_indicator() -> void:
	offscreen_indicator.rotation_degrees = -rotation_degrees
	offscreen_indicator.global_position.y = 0
	offscreen_indicator.global_position.x = position.x
	# scale offscreen_indicator based on distance from top of viewport
	# fuckin.. math


func _on_RigidBall_body_entered(body: Node) -> void:
	var hit_what := ""
	var sound_type := -1
	
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
	elif body is Target:
		hit_what = "target"
		body.hit()
	
	# floor sound is handled by `_on_FloorDetector` so it doesn't spam while rolling
	if sound_type >= 0 and sound_type < SoundType.size():
		audio_player.play_bump(sound_type)
	
	if not hit_what == "" and not is_on_floor:
		emit_signal("hit", hit_what)
		prints(hit_what,": ", linear_velocity.length())


func _on_FloorDetector_body_entered_exited(body: Node, has_entered: bool) -> void:
	if not body.name == "Floor":
		return
	
	is_on_floor = has_entered
	if has_entered:
		ftimer.start()
		audio_player.play_bump(SoundType.NORMAL)
	else:
		ftimer.stop()


func _on_FloorTimer_timeout() -> void:
	emit_signal("stuck_on_floor")
