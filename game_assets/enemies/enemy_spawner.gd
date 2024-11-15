class_name EnemySpawner
extends Node

const enemy_tsc : PackedScene = preload("res://game_assets/enemies/basic_enemy/basic_enemy.tscn")

var timer : Timer

@onready var root = get_parent()


func _ready() -> void:
	timer = Timer.new()
	timer.timeout.connect(_spawn_enemy)
	add_child(timer)
	timer.start(5)

func _spawn_enemy() -> void:
	var enemy = enemy_tsc.instantiate()
	
	var angle = randf_range(0, 2*PI)
	var direction = Vector2(0, -1)
	direction = direction.rotated(angle)
	var position = PlayerStats.player_global_position + 100 * direction
	
	enemy.position = position
	get_parent().add_child(enemy)
