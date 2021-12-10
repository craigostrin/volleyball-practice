extends RigidBody2D

onready var vis_notifier: VisibilityNotifier2D = $VisibilityNotifier2D
onready var offscreen_indicator: Node2D = $OffscreenIndicator


func _ready() -> void:
	vis_notifier.connect("screen_entered", self, "screen_entered_exited", [true])
	vis_notifier.connect("screen_exited", self, "screen_entered_exited", [false])
	offscreen_indicator.hide()


func _physics_process(delta: float) -> void:
	move_offscreen_indicator()


func move_offscreen_indicator() -> void:
	offscreen_indicator.rotation_degrees = -rotation_degrees
	offscreen_indicator.global_position.y = 0
	offscreen_indicator.global_position.x = position.x


func screen_entered_exited(has_entered: bool) -> void:
	offscreen_indicator.visible = !has_entered
