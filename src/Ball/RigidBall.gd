extends RigidBody2D

signal hit(what)
signal stuck_on_floor

# used to cancel out `hit` signals while on floor to prevent hit-counter cheating
var is_on_floor := false

enum SoundType { LIGHT, NORMAL, HEAVY }

onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
onready var vis_notifier: VisibilityNotifier2D = $VisibilityNotifier2D
onready var offscreen_indicator: Node2D = $OffscreenIndicator
onready var ftimer: Timer = $FloorDetector/FloorTimer


func _ready() -> void:
	vis_notifier.connect("screen_entered", self, "screen_entered_exited", [true])
	vis_notifier.connect("screen_exited", self, "screen_entered_exited", [false])
	offscreen_indicator.hide()
	
	connect("body_entered", self, "_on_RigidBall_body_entered")
	$FloorDetector.connect("body_entered", self, "_on_FloorDetector_body_entered_exited", [true])
	$FloorDetector.connect("body_exited", self, "_on_FloorDetector_body_entered_exited", [false])
	ftimer.connect("timeout", self, "_on_FloorTimer_timeout")


func _physics_process(delta: float) -> void:
	move_offscreen_indicator()


func move_offscreen_indicator() -> void:
	offscreen_indicator.rotation_degrees = -rotation_degrees
	offscreen_indicator.global_position.y = 0
	offscreen_indicator.global_position.x = position.x


func screen_entered_exited(has_entered: bool) -> void:
	offscreen_indicator.visible = !has_entered


func _on_RigidBall_body_entered(body: Node) -> void:
	var hit_what := ""
	
	if body.is_in_group("wall"):
		hit_what = "wall"
		audio_player.play_bump(SoundType.LIGHT)
	elif body.is_in_group("platform"):
		hit_what = "platform"
		audio_player.play_bump(SoundType.NORMAL)
	
	# floor sound is handled by `_on_FloorDetector` so it doesn't spam while rolling
	
	if not hit_what == "" and not is_on_floor:
		emit_signal("hit", hit_what)
	#prints(hit_what,": ", linear_velocity.length_squared())


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
