extends Control

var game_scene := preload("res://src/Game.tscn").instance()


func _on_FreePlayButton_pressed() -> void:
	start_game(false)


func _on_TargetModeButton_pressed() -> void:
	start_game(true)


func start_game(is_target_mode: bool) -> void:
	game_scene.target_mode = is_target_mode
	get_tree().get_root().add_child(game_scene)
	queue_free()
