extends StaticBody2D


onready var collider: CollisionShape2D = $CollisionShape2D
onready var timer: Timer = $Timer


func _ready() -> void:
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_on_Timer_timeout")


func reset(time: float) -> void:
	show()
	collider.set_deferred("disabled", false)
	timer.start(time)


func _on_Timer_timeout() -> void:
	collider.set_deferred("disabled", true)
	hide()
