extends Area2D
class_name Target

signal hit


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(_body) -> void:
	# play animation
	# play sfx
	emit_signal("hit")
	queue_free() # on_animation_finished
	print(name + " target hit")
