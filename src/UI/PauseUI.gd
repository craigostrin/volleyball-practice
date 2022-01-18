extends CanvasLayer


func _ready() -> void:
	show_pause(false)


func show_pause(show: bool) -> void:
	$PausePanel.visible = show
