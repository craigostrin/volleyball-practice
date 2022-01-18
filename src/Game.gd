extends Node2D
### TO DO ###

# target mode

# input remapping
# settings, including detailed UI options (remember, default: hit trackers off)
# font
# main menu, mode selection

# STATS
## save a file with Best stats and Avg stats
## lots of fun stuff for targets, like "avg platform hits per target scored


# OPTIONAL
# play: "story" mode with voice or text thoughts, possibly as targets
# UI: ball's offscreen indicator gets smaller as the ball gets further away
# sound: arms swinging? :/
# play/UI: challenges, special moves, score?
## like, bounce ball off head and then hit wall
## bump ball twice w/o hitting wall, then hit wall on 3rd bump

# possibly v1.5 or 2.0:
## 2 player mode!
## target score mode with bonuses/combo multiplier for special moves (eg, off the head, off the floor, off both walls)


const ball_scene := preload("res://src/Ball/RigidBall.tscn")
const target_controller_scene := preload("res://src/Targets/TargetController.tscn")

export var target_mode := false
export var ball_launcher_impulse := 600.0

var ball: RigidBody2D
var target_controller: Node2D
#var rng := RandomNumberGenerator.new()

onready var ui:                       CanvasLayer = $UI
onready var pause_ui:                 CanvasLayer = $PauseUI
onready var ball_spawn_pos:           Vector2 = $BallSpawn.position
onready var ball_release:             StaticBody2D = $BallSpawn/BallRelease
onready var ball_launcher:            Position2D = $BallLauncher
onready var platform_hit_count_timer: Timer = $PlatformHitCountTimer
onready var wall_hit_count_timer:     Timer = $WallHitCountTimer


func _ready() -> void:
	if target_mode:
		target_controller = target_controller_scene.instance() as Node2D
		target_controller.connect("target_hit", self, "_on_target_hit")
		add_child(target_controller)
	ball = spawn_ball()
	#ball = launch_ball()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_ball"): # LEAVE THIS IN, JUST REMOVE TILDE (maybe)
		ball = reset_ball()
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pause_ui.show_pause(get_tree().paused)


func spawn_ball() -> RigidBody2D:
	var new_ball = new_ball()
	new_ball.position = ball_spawn_pos
	return new_ball


func launch_ball() -> RigidBody2D:
	var new_ball = new_ball()
	new_ball.position = ball_launcher.position
	new_ball.apply_central_impulse(Vector2(0, -ball_launcher_impulse).rotated(ball_launcher.rotation))
	return new_ball


func new_ball() -> RigidBody2D:
	var b: RigidBody2D = ball_scene.instance()
	# warning-ignore:return_value_discarded
	b.connect("stuck_on_floor", self, "_on_ball_stuck_on_floor")
	# warning-ignore:return_value_discarded
	b.connect("hit", self, "_on_ball_hit")
	# warning-ignore:return_value_discarded
	if is_instance_valid(target_controller):
		b.connect("touched_player", self, "_on_ball_touched_player")
	add_child(b)
	return b


func reset_ball() -> RigidBody2D:
	if ball:
		ball.queue_free()
	ui.new_ball()
	ball_release.reset()
	return spawn_ball()
	#return launch_ball()


func _on_ball_stuck_on_floor() -> void:
	ball = reset_ball()


func _on_ball_hit(hit_what: String) -> void:
	if hit_what == "wall" and wall_hit_count_timer.is_stopped():
		ui.add_wall_hit()
		wall_hit_count_timer.start()
		prints("wall hit counted:", ui._wall_hits)
	elif hit_what == "wall" and not wall_hit_count_timer.is_stopped():
		print("*wall hit DISCARDED")
	if hit_what == "platform" and platform_hit_count_timer.is_stopped():
		ui.add_platform_hit()
		platform_hit_count_timer.start()
		prints("platform hit counted:", ui._platform_hits)
	elif hit_what == "platform" and not platform_hit_count_timer.is_stopped():
		print("*platform hit DISCARDED")


func _on_ball_touched_player() -> void:
	# new_ball() already checks if there's a TC, so this is just for safety
	assert(is_instance_valid(target_controller))
	target_controller.on_player_touched()


func _on_target_hit() -> void:
	ui.add_target_hit()
