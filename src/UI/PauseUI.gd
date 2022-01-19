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
	$UISettingsPanel.hide()
	# DEBUG
	$PausePanel/VBoxContainer/UISettingsButton.connect("pressed", self, "_on_UISettingsButton_pressed")
	$PausePanel/VBoxContainer/ControlsButton.connect("pressed", self, "_onControlsButton_pressed")

# DEBUG
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		$UISettingsPanel.hide()
		$ControlsPanel.hide()


func show_pause(show: bool) -> void:
	$PausePanel.visible = show


func _on_UISettingsButton_pressed() -> void:
	$UISettingsPanel.show()


func _onControlsButton_pressed() -> void:
	$ControlsPanel.show()
