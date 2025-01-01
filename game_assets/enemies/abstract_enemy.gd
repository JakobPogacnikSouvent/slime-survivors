class_name AbstractEnemy
extends CharacterBody2D

@export var speed : int
@export var spawning_weight : float
@export var max_hp : int
@export var score : int

const projectile_tsc : PackedScene = preload("res://game_assets/projectile/projectile.tscn")

var is_in_death_animation : bool = false

var hp : int:
	set(new_hp):
		hp = clamp(new_hp, 0, max_hp)

@onready var timer : Timer = $AttackTimer

func _ready() -> void:
	timer.timeout.connect(attack)
	timer.start()
	
	hp = max_hp


func is_off_screen() -> bool:
	return (abs(self.global_position.x - PlayerStats.player_global_position.x) > 160 or
		abs(self.global_position.y - PlayerStats.player_global_position.y) > 90)


func attack() -> void:
	pass


func take_damage(dmg : int, direction : Vector2) -> void:
	hp -= dmg
	if hp == 0:
		die(direction)


func die(direction : Vector2) -> void:
	GameManager.score += score
	GameManager.kills += 1
