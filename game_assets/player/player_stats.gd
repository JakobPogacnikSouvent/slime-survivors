extends Node

const max_hp : int = 3
@export var HP : int = 3:
	set(new_hp):
		HP = clamp(new_hp, 0, max_hp)
		player_hp_changed.emit()
		
var player_global_position : Vector2
var mouse_direction : Vector2

signal player_hp_changed

func take_damage(damage : int) -> void:
	HP -= damage
