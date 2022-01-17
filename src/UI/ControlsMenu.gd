extends Control

onready var _input_mapper: Node = $InputMapper
onready var _action_list: VBoxContainer = $VBox/ScrollContainer/ActionList
onready var _profile_selector: OptionButton = $VBox/ProfileSelector

func _ready() -> void:
	_input_mapper.connect("profile_changed", self, "rebuild")
	_profile_selector.initialize(_input_mapper)
	_input_mapper.change_profile(_profile_selector.selected)


func rebuild(input_profile, is_customizable := false):
	_action_list.clear()
	for input_action in input_profile.keys():
		var line = _action_list.add_input_line(input_action, \
			input_profile[input_action], is_customizable)
		if is_customizable:
			line.connect("change_button_pressed", self, \
				"_on_Input_line_change_button_pressed", [input_action, line])
