extends StaticBody2D


onready var collider: CollisionShape2D = $CollisionShape2D
onready var timer: Timer = $Timer


func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")


func reset() -> void:
	collider.set_deferred("disabled", false)
	timer.start()


func _on_Timer_timeout() -> void:
	collider.set_deferred("disabled", true)
