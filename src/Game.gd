extends Node2D
### TO DO ###
# button to turn around
# mini achievements
# like, bounce ball off head and then hit wall
# bump ball twice w/o hitting wall, then hit wall on 3rd bump
# possibly v1.5
# 2.0: 2 player mode!


const ball_scene := preload("res://src/Ball/RigidBall.tscn")

onready var ball: RigidBody2D = $RigidBall
onready var ball_spawn_pos: Vector2 = $BallSpawn.position
onready var ball_release: StaticBody2D = $BallSpawn/BallRelease


func _ready() -> void:
	ball.connect("stuck_on_floor", self, "_on_ball_stuck_on_floor")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_ball"): # LEAVE THIS IN, JUST REMOVE TILDE (maybe)
		ball = reset_ball()


func spawn_ball() -> RigidBody2D:
	var new_ball: RigidBody2D = ball_scene.instance()
	new_ball.connect("stuck_on_floor", self, "_on_ball_stuck_on_floor")
	new_ball.position = ball_spawn_pos
	add_child(new_ball)
	return new_ball


func reset_ball() -> RigidBody2D:
	ball.queue_free()
	ball_release.reset()
	return spawn_ball()


func _on_ball_stuck_on_floor() -> void:
	ball = reset_ball()
