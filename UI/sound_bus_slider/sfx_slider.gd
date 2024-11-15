class_name SoundBusSlider
extends Control
## A slider to manage volume of audio buses.
##
## Sets bus_name db value to slider ratio and
## plays a test sound if provided.

@export var bus_name : String
@export var test_sound : AudioStreamWAV

var bus_index : int

@onready var slider : HSlider = $HBoxContainer/HSlider
@onready var value_label : Label = $HBoxContainer/Value
@onready var sound_player : AudioStreamPlayer = $TestSound


func _ready() -> void:
	slider.value_changed.connect(_update_value_label)
	slider.drag_ended.connect(_play_sound_test.unbind(1))
	
	bus_index = AudioServer.get_bus_index(bus_name)
	
	if test_sound:
		sound_player.stream = test_sound
	
	var volume = AudioServer.get_bus_volume_db(bus_index)
	var i = db_to_linear(volume) * slider.max_value
	slider.value = int(i)
	

func _update_value_label(value : float) -> void:
	value_label.text = str(int(value))
	
	var value_ratio = value / slider.max_value
	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value_ratio))


func _play_sound_test() -> void:
	if test_sound:
		sound_player.play()
