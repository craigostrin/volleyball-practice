extends RigidBody2D

var is_on_floor := false
var floortestind := 0

onready var vis_notifier: VisibilityNotifier2D = $VisibilityNotifier2D
onready var offscreen_indicator: Node2D = $OffscreenIndicator


func _ready() -> void:
	vis_notifier.connect("screen_entered", self, "screen_entered_exited", [true])
	vis_notifier.connect("screen_exited", self, "screen_entered_exited", [false])
	offscreen_indicator.hide()
	
	connect("body_entered", self, "_on_RigidBall_body_entered")
	connect("body_exited", self, "_on_RigidBall_body_exited")


func _physics_process(delta: float) -> void:
	move_offscreen_indicator()


func move_offscreen_indicator() -> void:
	offscreen_indicator.rotation_degrees = -rotation_degrees
	offscreen_indicator.global_position.y = 0
	offscreen_indicator.global_position.x = position.x


func screen_entered_exited(has_entered: bool) -> void:
	offscreen_indicator.visible = !has_entered


func _on_RigidBall_body_entered(body: Node) -> void:
	if body.name == "Floor" and not is_on_floor:
		prints("ay i'm on da floor ", floortestind)
		is_on_floor = true
		floortestind += 1


func _on_RigidBall_body_exited(body: Node) -> void:
	if body.name == "Floor":
		is_on_floor = false
		prints("ay no mo flo", floortestind)
