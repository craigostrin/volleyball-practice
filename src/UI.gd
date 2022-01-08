extends CanvasLayer

var _platform_hits := 0 setget set_platform_hits
var _platform_last := 0 setget set_platform_last
var _platform_best := 0 setget set_platform_best

var _wall_hits := 0 setget set_wall_hits
var _wall_last := 0 setget set_wall_last
var _wall_best := 0 setget set_wall_best

onready var platform_hits_label: Label = $HBoxContainer/PlatformPanel/VBox/HitsLabel
onready var platform_last_label: Label = $HBoxContainer/PlatformPanel/VBox/LastLabel
onready var platform_best_label: Label = $HBoxContainer/PlatformPanel/VBox/BestLabel

onready var wall_hits_label: Label = $HBoxContainer/WallPanel/VBox/HitsLabel
onready var wall_last_label: Label = $HBoxContainer/WallPanel/VBox/LastLabel
onready var wall_best_label: Label = $HBoxContainer/WallPanel/VBox/BestLabel


func _ready() -> void:
	full_reset()


# INCREASE COUNTERS
func add_platform_hit() -> void:
	self._platform_hits += 1

func add_wall_hit() -> void:
	self._wall_hits += 1


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


func full_reset() -> void:
	self._platform_hits = 0
	self._platform_last = 0
	self._platform_best = 0
	self._wall_hits = 0
	self._wall_last = 0
	self._wall_best = 0


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
