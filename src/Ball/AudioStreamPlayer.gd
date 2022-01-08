extends AudioStreamPlayer

const light1 := preload("res://sound/light1_bump9.wav")
const light2 := preload("res://sound/light2_bump1.wav")
const light3 := preload("res://sound/light3_bump2.wav")
const very_light := preload("res://sound/light_very_bump3.wav")
const normal1 := preload("res://sound/normal1_bump4.wav")
const normal2 := preload("res://sound/normal2_bump5.wav")
const normal3 := preload("res://sound/normal3_bump8.wav")
const heavy1 := preload("res://sound/heavy1_bump6.wav")
const heavy2 := preload("res://sound/heavy2_bump7.wav")

var lights := [ light1, light2, light3, very_light ]
var normals := [ normal1, normal2, normal3 ]
var heavys := [ heavy1, heavy2 ]

onready var rng := RandomNumberGenerator.new()


func play_bump(SoundType_enum := 1) -> void:
	var lib := []
	match SoundType_enum:
		0: # LIGHT
			lib = lights
		1: # NORMAL
			lib = normals
		2: # HEAVY
			lib = heavys
		_:
			printerr("Ball AudioStreamPlayer received invalid SoundType. Expects 0 - 2.")
			return
	
	var ri := rng.randi() % lib.size()
	var sound: AudioStreamSample = lib[ri]
	if stream != sound:
		stream = sound
	play()
