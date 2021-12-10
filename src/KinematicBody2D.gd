extends KinematicBody2D


func _physics_process(delta: float) -> void:
	var move_dir := get_input()
	var velocity := move_dir * 5.0
	var collision = move_and_collide(velocity)
	if collision:
		print(collision.collider)
		if collision.collider is RigidBody2D:
			collision.collider.apply_impulse(Vector2.ZERO, Vector2(0, 200))


func get_input() -> Vector2:
	var move_dir := Vector2.ZERO
	
	move_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return move_dir
