extends CanvasLayer

var _platform_hits := 0 setget set_platform_hits
var _platform_last := 0 setget set_platform_last
var _platform_best := 0 setget set_platform_best

var _wall_hits := 0 setget set_wall_hits
var _wall_last := 0 setget set_wall_last
var _wall_best := 0 setget set_wall_best

var _target_hits := 0 setget set_target_hits

onready var platform_hits_label: Label = $HBoxContainer/PlatformPanel/VBox/HitsLabel
onready var platform_last_label: Label = $HBoxContainer/PlatformPanel/VBox/LastLabel
onready var platform_best_label: Label = $HBoxContainer/PlatformPanel/VBox/BestLabel

onready var wall_hits_label: Label = $HBoxContainer/WallPanel/VBox/HitsLabel
onready var wall_last_label: Label = $HBoxContainer/WallPanel/VBox/LastLabel
onready var wall_best_label: Label = $HBoxContainer/WallPanel/VBox/BestLabel

onready var target_hits_label: Label = $TargetPanel/VBoxContainer/HitsLabel


func _ready() -> void:
	full_reset()


func show_target_counter(val: bool) -> void:
	$TargetPanel.visible = val


# INCREASE COUNTERS
func add_platform_hit() -> void:
	self._platform_hits += 1

func add_wall_hit() -> void:
	self._wall_hits += 1

func add_target_hit() -> void:
	self._target_hits += 1


# RESETS
func new_ball() -> void:
	self._platform_last = _platform_hits
	self._platform_hits = 0
	if _platform_last > _platform_best:
		self._platform_best = _platform_last
	
	self._wall_last = _wall_hits
	self._wall_hits = 0
	if _wall_last > _wall_best:
		self._wall_best = _wall_last
	
	self._target_hits = 0


func full_reset() -> void:
	self._platform_hits = 0
	self._platform_last = 0
	self._platform_best = 0
	self._wall_hits = 0
	self._wall_last = 0
	self._wall_best = 0
	self._target_hits = 0


# SETTERS
func set_platform_hits(val: int) -> void:
	_platform_hits = val
	platform_hits_label.text = "Hits: " + str(_platform_hits)

func set_platform_last(val: int) -> void:
	_platform_last = val
	platform_last_label.text = "Last: " + str(_platform_last)

func set_platform_best(val: int) -> void:
	_platform_best = val
	platform_best_label.text = "Best: " + str(_platform_best)


func set_wall_hits(val: int) -> void:
	_wall_hits = val
	wall_hits_label.text = "Hits: " + str(_wall_hits)

func set_wall_last(val: int) -> void:
	_wall_last = val
	wall_last_label.text = "Last: " + str(_wall_last)

func set_wall_best(val: int) -> void:
	_wall_best = val
	wall_best_label.text = "Best: " + str(_wall_best)


func set_target_hits(val: int) -> void:
	_target_hits = val
	target_hits_label.text = str(_target_hits)
	

# UI visibility settings # DEBUG / PLACEHOLDER messy
func check_Platform_label_visibility() -> void:
	if platform_hits_label.visible or platform_last_label.visible or platform_best_label.visible:
		$HBoxContainer/PlatformPanel.visible = true
	else:
		$HBoxContainer/PlatformPanel.visible = false

func check_Wall_label_visibility() -> void:
	if wall_hits_label.visible or wall_last_label.visible or wall_best_label.visible:
		$HBoxContainer/WallPanel.visible = true
	else:
		$HBoxContainer/WallPanel.visible = false


func _on_PlatformHitsCheckBox_toggled(button_pressed: bool) -> void:
	platform_hits_label.visible = button_pressed
	check_Platform_label_visibility()

func _on_PlatformLastCheckBox_toggled(button_pressed: bool) -> void:
	platform_last_label.visible = button_pressed
	check_Platform_label_visibility()

func _on_PlatformBestCheckBox_toggled(button_pressed: bool) -> void:
	platform_best_label.visible = button_pressed
	check_Platform_label_visibility()


func _on_WallHitsCheckBox_toggled(button_pressed: bool) -> void:
	wall_hits_label.visible = button_pressed
	check_Wall_label_visibility()

func _on_WallLastCheckBox_toggled(button_pressed: bool) -> void:
	wall_last_label.visible = button_pressed
	check_Wall_label_visibility()

func _on_WallBestCheckBox_toggled(button_pressed: bool) -> void:
	wall_best_label.visible = button_pressed
	check_Wall_label_visibility()
