extends Node2D

const target_scene := preload("res://src/Targets/Target.tscn")
var rng := RandomNumberGenerator.new()
var screen_width: float

var target: Target

export var min_dist_from_wall := 35.0
export var min_dist_from_top := 35.0
export var wall_vertical_range := 300
export var center_vertical_range := 230

enum TargetArea { LEFT_WALL, CENTER, RIGHT_WALL }
export(TargetArea) var spawn_targets_where := TargetArea.LEFT_WALL
var is_next_target_hittable := false

onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	rng.randomize()
	screen_width = get_viewport_rect().size.x
	target = spawn_target(spawn_targets_where)


func spawn_target(target_area) -> Target:
	var t: Target = target_scene.instance()
	var rpos := Vector2()
	t.connect("hit", self, "_on_target_hit")
	add_child(t)
	
	match target_area:
		TargetArea.LEFT_WALL:
			rpos = Vector2(min_dist_from_wall, (rng.randi() % wall_vertical_range) + min_dist_from_top)
		TargetArea.CENTER:
			var x := rng.randf_range(min_dist_from_wall * 3, screen_width - (min_dist_from_wall * 3))
			var y := rng.randi() % center_vertical_range + min_dist_from_top
			rpos = Vector2(x, y)
		TargetArea.RIGHT_WALL:
			rpos = Vector2( screen_width - min_dist_from_wall, (rng.randi() % wall_vertical_range) + min_dist_from_top )
	
	t.position = rpos
	t.set_shape(target_area)
	t.hittable = is_next_target_hittable
	
	is_next_target_hittable = false
	return t


func get_random_target_area() -> int:
	return rng.randi() % TargetArea.size()


func _on_target_hit() -> void:
	is_next_target_hittable = false
	owner.ui.add_target_hit()
	spawn_timer.start()
	yield(spawn_timer, "timeout")
	target = spawn_target(spawn_targets_where)


# Called by Game when the ball touches any part of the player
func on_player_touched() -> void:
	is_next_target_hittable = true
	if is_instance_valid(target):
		target.hittable = true
