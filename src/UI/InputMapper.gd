extends Node

signal profile_changed(new_profile, is_customizable)

var current_profile_id := 0
var profiles := {
	0: "profile_default",
	1: "profile_laptop", # if I launch with 2-player mode, laptops won't use Numpad
	2: "profile_custom"
}

var profile_default := {
	"move_left"  : KEY_W,
	"move_right" : KEY_D,
	"pass"       : KEY_SPACE,
	"crouch"     : KEY_CONTROL,
	"flip"       : KEY_F,
	"reset_ball" : KEY_R,
	"pause"      : KEY_ESCAPE
}
