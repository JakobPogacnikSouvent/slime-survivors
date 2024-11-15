class_name SoundButton
extends Button
## Custom button class that adds sound effects.
##
## Plays a sound effect on click and focus entered.

@onready var click_sfx : AudioStreamPlayer = $Click
@onready var focus_sfx : AudioStreamPlayer = $Focus


func _ready() -> void:
	button_down.connect(_play_click)
	focus_entered.connect(_focus_changed.bind(true))
	focus_exited.connect(_focus_changed.bind(false))
	mouse_entered.connect(grab_focus)


func _play_click() -> void:
	click_sfx.play()


func _play_select() -> void:
	focus_sfx.play()


func _focus_changed(focus_just_entered : bool) -> void:
	if focus_just_entered:
		_play_select()
		modulate = Color(1.5, 1.5, 1.5)
	else:
		# If focus exited reset modulate
		modulate = Color(1, 1, 1)
