extends Node2D

const ball_scene := preload("res://src/RigidBall.tscn")

onready var ball: RigidBody2D = $RigidBall
onready var ball_release_block: StaticBody2D = $BallRelease
onready var ball_release_timer: Timer = $BallRelease/Timer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_ball"):
		ball.queue_free()
		ball = ball_scene.instance()
		ball.position = $BallSpawnPosition.position
		add_child(ball)


func _ready() -> void:
	ball_release_timer.connect("timeout", self, "_on_BallRelease_timeout")


func _on_BallRelease_timeout() -> void:
	$BallRelease/CollisionShape2D.disabled = true
