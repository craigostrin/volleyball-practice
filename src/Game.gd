extends Node2D
### TO DO ###

## NEXT:
# - new mode (score via alternating walls)
# - mode: hit ball up once before hitting wall
# - make a few ball gravity options 
# - make the ball heavier by default
# - save high scores 
# - fix UI
# - remove bugtesting main menu

# LATER:
# - target mode
# - input remapping

# UNSORTED
# - settings, including detailed UI options (remember, default: hit trackers off)
# - font
# - main menu, mode selection
# - sound: arms swinging? :/

# STATS
## save a file with Best stats and Avg stats
## lots of fun stuff for targets, like "avg platform hits per target scored

# possibly v1.5 or 2.0:
## 2 player mode!
## target score mode with bonuses/combo multiplier for special moves (eg, off the head, off the floor, off both walls)
## Beach mode: windy + wind indicator, for extra challenge

const ball_scene := preload("res://src/Ball/RigidBall.tscn")
const target_controller_scene := preload("res://src/Targets/TargetController.tscn")

export var ball_release_time := 3.0
export var target_mode := false
export var reset_on_floor := false
export var muted := false
export var ball_launcher_impulse := 600.0

var ball: Ball
var target_controller: Node2D

onready var player:                     Node2D      = $Player
onready var ui:                         CanvasLayer = $UI
onready var pause_ui:                   CanvasLayer = $PauseUI
onready var ball_spawn_pos:             Vector2 = $BallSpawn.position
onready var ball_release:               StaticBody2D = $BallSpawn/BallRelease
onready var ball_launcher:              Position2D = $BallLauncher
onready var platform_hit_count_timer:   Timer = $PlatformHitCountTimer
onready var wall_hit_count_timer:       Timer = $WallHitCountTimer
onready var floor_reset_checkbox:       CheckBox = $PauseUI/PausePanel/VBoxContainer/ResetOnFloorHbox/FloorResetCheckBox
onready var mute_checkbox:              CheckBox = $PauseUI/PausePanel/VBoxContainer/MuteHbox/MuteChecbox

func _ready() -> void:
	floor_reset_checkbox.connect("toggled", self, "_on_floor_reset_checkbox_toggled")
	mute_checkbox.connect("toggled", self, "_on_mute_checkbox_toggled")
	
	if target_mode:
		target_controller = target_controller_scene.instance() as Node2D
		target_controller.connect("target_hit", self, "_on_target_hit")
		add_child(target_controller)
		ui.show_target_counter(true)
	else:
		ui.show_target_counter(false)
	ball = spawn_ball()
	#ball = launch_ball()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_ball"): # LEAVE THIS IN, JUST REMOVE TILDE (maybe)
		ball = reset_ball()
	if event.is_action_pressed("reset_ball_and_player"): # LEAVE THIS IN, JUST REMOVE TILDE (maybe)
		ball = reset_ball()
		reset_player()
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		pause_ui.show_pause(get_tree().paused)


func spawn_ball() -> Ball:
	var new_ball = new_ball()
	new_ball.position = ball_spawn_pos
	new_ball.muted = muted
	return new_ball


func new_ball() -> Ball:
	var b: Ball = ball_scene.instance()
	# warning-ignore:return_value_discarded
	b.connect("stuck_on_floor", self, "_on_ball_stuck_on_floor")
	# warning-ignore:return_value_discarded
	b.connect("hit", self, "_on_ball_hit")
	# warning-ignore:return_value_discarded
	if is_instance_valid(target_controller):
		b.connect("touched_player", self, "_on_ball_touched_player")
	add_child(b)
	return b


func reset_ball() -> Ball:
	if is_instance_valid(ball):
		ball.queue_free()
	ui.new_ball()
	ball_release.reset(ball_release_time)
	return spawn_ball()


func reset_player() -> void:
	if is_instance_valid(player):
		player.position.x = 325


func launch_ball() -> Ball:
	var new_ball = new_ball()
	new_ball.position = ball_launcher.position
	new_ball.apply_central_impulse(Vector2(0, -ball_launcher_impulse).rotated(ball_launcher.rotation))
	return new_ball


func _on_ball_stuck_on_floor() -> void:
	ball = reset_ball()


func _on_ball_hit(hit_what: String) -> void:
	## Discard multi-hits and add +1 to UI counters
	## If ball hit floor and `Reset on Floor` is on, reset ball
	
	# if hit Wall
	if hit_what == "wall" and wall_hit_count_timer.is_stopped():
		ui.add_wall_hit()
		wall_hit_count_timer.start()
		#prints("wall hit counted:", ui._wall_hits)
	elif hit_what == "wall" and not wall_hit_count_timer.is_stopped():
		print("*wall hit DISCARDED")
	
	# if hit Platform
	if hit_what == "platform" and platform_hit_count_timer.is_stopped():
		ui.add_platform_hit()
		platform_hit_count_timer.start()
		#prints("platform hit counted:", ui._platform_hits)
	elif hit_what == "platform" and not platform_hit_count_timer.is_stopped():
		print("*platform hit DISCARDED")
	
	# if hit Floor
	if hit_what == "floor" and reset_on_floor:
		ball = reset_ball()


func _on_ball_touched_player() -> void:
	# new_ball() already checks if there's a TC, so this is just for safety
	assert(is_instance_valid(target_controller))
	target_controller.on_player_touched()


func _on_target_hit() -> void:
	ui.add_target_hit()


func _on_floor_reset_checkbox_toggled(is_button_pressed: bool) -> void:
	reset_on_floor = is_button_pressed

func _on_mute_checkbox_toggled(is_button_pressed: bool) -> void:
	muted = is_button_pressed
	if ball:
		ball.muted = muted
