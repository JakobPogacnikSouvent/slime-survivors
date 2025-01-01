extends Node

const max_hp : int = 3
@export var HP : int = 3:
	set(new_hp):
		HP = clamp(new_hp, 0, max_hp)
		player_hp_changed.emit()
		
		if HP == 0:
			player_died.emit()
		
var player_global_position : Vector2
var mouse_direction : Vector2
var velocity : Vector2

signal player_hp_changed
signal player_died

signal player_moved
signal player_dashed
signal mirror_charged

func take_damage(damage : int) -> void:
	HP -= damage
