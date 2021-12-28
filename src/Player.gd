extends Node2D

export var speed := 200.0
export var platform_max_rotation := 90.0

onready var platform: Node2D = $Platform
onready var anim_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	anim_player.connect("animation_finished", self, "_on_animation_finished")
	# play the RESET anim on ball collision


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pass"):
		anim_player.play("Pass")
	if event.is_action_pressed("reset_platform"): 
		anim_player.play("Reset")


func _physics_process(delta: float) -> void:
	var move_vec := get_movement()
	if move_vec != Vector2.ZERO:
		position += move_vec * speed * delta


func get_movement() -> Vector2:
	var move_vec := Vector2.ZERO
	
	move_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	return move_vec
