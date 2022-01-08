extends Node2D
### TO DO ###
# sound: make it based on Ball velocity, set up floor
# sound: arms swinging? :/
# UI, art
# hit tracker (both wall + platform are optional. default: off)
# button to turn around
# mini achievements (eh, fuck this)
# like, bounce ball off head and then hit wall
# bump ball twice w/o hitting wall, then hit wall on 3rd bump
# possibly v1.5
# 2.0: 2 player mode!


const ball_scene := preload("res://src/Ball/RigidBall.tscn")

var ball: RigidBody2D

onready var ui: CanvasLayer = $UI
onready var ball_spawn_pos: Vector2 = $BallSpawn.position
onready var ball_release: StaticBody2D = $BallSpawn/BallRelease


func _ready() -> void:
	ball = spawn_ball()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_ball"): # LEAVE THIS IN, JUST REMOVE TILDE (maybe)
		ball = reset_ball()


func spawn_ball() -> RigidBody2D:
	var new_ball: RigidBody2D = ball_scene.instance()
	new_ball.connect("stuck_on_floor", self, "_on_ball_stuck_on_floor")
	new_ball.connect("hit", self, "_on_ball_hit")
	new_ball.position = ball_spawn_pos
	add_child(new_ball)
	return new_ball


func reset_ball() -> RigidBody2D:
	if ball:
		ball.queue_free()
	ui.new_ball()
	ball_release.reset()
	return spawn_ball()


func _on_ball_stuck_on_floor() -> void:
	ball = reset_ball()


func _on_ball_hit(hit_what: String) -> void:
	if hit_what == "wall":
		ui.add_wall_hit()
	if hit_what == "platform":
		ui.add_platform_hit()
