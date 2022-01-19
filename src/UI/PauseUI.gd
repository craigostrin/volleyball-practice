extends CanvasLayer

signal ui_set()

onready var platform_hits_button: CheckBox = $UISettingsPanel/VBoxContainer/PlatformHits/CheckBox
onready var platform_last_button: CheckBox = $UISettingsPanel/VBoxContainer/PlatformLast/CheckBox
onready var platform_best_button: CheckBox = $UISettingsPanel/VBoxContainer/PlatformBest/CheckBox
onready var wall_hits_button: CheckBox = $UISettingsPanel/VBoxContainer/WallHits/CheckBox
onready var wall_last_button: CheckBox = $UISettingsPanel/VBoxContainer/WallLast/CheckBox
onready var wall_best_button: CheckBox = $UISettingsPanel/VBoxContainer/WallBest/CheckBox


func _ready() -> void:
	show_pause(false)


func show_pause(show: bool) -> void:
	$PausePanel.visible = show


func _on_platform_hits():
	pass

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	pass # Replace with function body.
