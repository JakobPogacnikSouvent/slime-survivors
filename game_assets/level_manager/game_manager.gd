extends Node
## Spawns enemies, increases game difficulty and keeps score

var level : int = 1:
	set(new_level):
		level = new_level
		print("level up")
		level_increased.emit()
		
var multiplier : float = 1.0
var spawn_credits : int = 10
var score : int:
	set(new_score):
		score = new_score
		score_updated.emit()

var difficulty_timer : Timer
var spawn_timer : Timer

@onready var root = get_parent()

const basic_enemy_tsc : PackedScene = preload("res://game_assets/enemies/basic_enemy/basic_enemy.tscn")

signal level_increased
signal score_updated

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(_spawn_enemy)
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.start(5)


func speed_up() -> void:
	multiplier += 0.1
	Engine.set_time_scale(multiplier)
	

func _spawn_enemy() -> void:
	# Pick position in circle 320 units away
	const RADIUS = 160
	
	var angle = randf_range(0, 2*PI)
	var direction = Vector2(0, -1).rotated(angle)
	var spawn_position = PlayerStats.player_global_position + RADIUS * direction
	
	# Spawn enemy
	var weighted_array = WeightedArray.new()
	
	var basic_enemy = basic_enemy_tsc.instantiate()
	weighted_array.append(basic_enemy, basic_enemy.spawning_weight)
	
	var enemy = weighted_array.get_random()
	
	enemy.position = spawn_position
	get_parent().add_child(enemy)
	
	# Restart spawn timer
	spawn_timer.start(2 + randf_range(1,3))
