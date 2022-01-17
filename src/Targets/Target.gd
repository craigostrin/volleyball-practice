extends Area2D
class_name Target

signal hit

# In between Target hits, the ball must touch the player before the next
# Target becomes hittable --- managed by `TargetController.on_player_touched()`
var hittable := false


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(_body) -> void:
	if not hittable:
		return
	
	# play animation
	# play sfx
	queue_free() # on_animation_finished
	print(name + " hit")
	emit_signal("hit")


# takes TargetController enum
func set_shape(TargetArea: int) -> void:
	match TargetArea:
		0: # LEFT
			pass
		1: # CENTER
			$SpriteWall.hide()
			$SpriteCenter.show()
			$CollisionShape2D.scale.x = 2.4
		2: # RIGHT
			scale.x = -1
		_:
			pass
