extends Node2D

export var start_flipped := false

export var speed := 220.0

export var move_left_action := "move_left"
export var move_right_action := "move_right"
export var pass_action := "pass"
export var crouch_action := "crouch"
export var flip_action := "flip"

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var anim_player_platform: AnimationPlayer = $Body/Platform/AnimationPlayer


func _ready() -> void:
# warning-ignore:return_value_discarded
	anim_player_platform.connect("animation_finished", self, "_on_Platform_animation_finished")
	if start_flipped:
		flip()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(pass_action):
		anim_player_platform.play("Pass")
	if event.is_action_pressed(crouch_action):
		anim_player.play("Crouch")
	if event.is_action_released(crouch_action):
		anim_player.play("Stand")
	if event.is_action_pressed(flip_action): 
		flip()


func _physics_process(delta: float) -> void:
	var move_vec := get_movement()
	if move_vec != Vector2.ZERO:
		position += move_vec * speed * delta
		position.x = clamp(position.x, -100, get_viewport_rect().size.x + 100)


func get_movement() -> Vector2:
	var move_vec := Vector2.ZERO
	
	move_vec.x = Input.get_action_strength(move_right_action) - Input.get_action_strength(move_left_action)
	
	return move_vec


func flip() -> void:
	scale.x *= -1


func _on_Platform_animation_finished(anim_name: String) -> void:
	if anim_name == "Pass":
		anim_player_platform.play("Reset")
