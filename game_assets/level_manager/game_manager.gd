extends Node
## Spawns enemies, increases game difficulty and keeps score

var level : int:
	set(new_level):
		level = new_level
		level_increased.emit()
		
var score : int:
	set(new_score):
		score = new_score
		score_updated.emit()
var kills : int = 0:
	set(new_kills):
		kills = new_kills
		killed_enemy.emit()

var high_score : int
var level_node : Level

var spawn_timer : Timer

var show_tutorial : bool = true
var guaranteed_big_boy : bool = false

@onready var root = get_parent()

const basic_enemy_tsc : PackedScene = preload("res://game_assets/enemies/basic_enemy/basic_enemy.tscn")
const aspid_tsc : PackedScene = preload("res://game_assets/enemies/aspid/aspid.tscn")
const big_boy_tsc : PackedScene = preload("res://game_assets/enemies/big_boy/big_boy.tscn")

signal level_increased
signal score_updated

signal reflected_projectile
signal reflected_big_projectile
signal killed_enemy


func start_game(l : Level):
	print("starting_game")
	level_node = l
	
	score = 0
	kills = 0
	level = 1
	PlayerStats.HP = 3
	guaranteed_big_boy = false
	
	spawn_timer = Timer.new()
	spawn_timer.timeout.connect(_spawn_enemy)
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.start(4)

func end_game():
	if score > high_score:
		high_score = score
	
	# Sometimes spawn timer is null for some reason
	if spawn_timer != null:
		spawn_timer.queue_free()
		remove_child(spawn_timer)
		spawn_timer = null


func _spawn_enemy() -> void:
	# Pick position in circle 320 units away
	const RADIUS = 160
	
	var angle = randf_range(0, 2*PI)
	var direction = Vector2(0, -1).rotated(angle)
	var spawn_position = PlayerStats.player_global_position + RADIUS * direction
	
	var enemy 
	
	if level == 2 and not guaranteed_big_boy:
		guaranteed_big_boy = true
		enemy = big_boy_tsc.instantiate()
	else:
		enemy = random_enemy()
	
	enemy.position = spawn_position
	level_node.add_child(enemy)
	
	# Restart spawn timer
	var spawn_time = max(5 - 0.3 * level, 0.5)
	var spawn_time_variance = max(2 - 0.2 * level, 0.1)
	spawn_timer.start(spawn_time + randf_range(0, spawn_time_variance))

func random_enemy() -> AbstractEnemy:
	# Spawn enemy
	var weighted_array = WeightedArray.new()
	
	var basic_enemy = basic_enemy_tsc.instantiate()
	var aspid = aspid_tsc.instantiate()
	var big_boy = big_boy_tsc.instantiate()
	
	var basic_enemy_weight = max(1 - 0.2 * (level - 1), 0.1)
	var aspid_weight = min(0.2 * level, 1)
	var big_boy_weight = min(0.2 * (level - 2), 1)
	
	weighted_array.append(basic_enemy, basic_enemy_weight)
	weighted_array.append(aspid, aspid_weight)
	weighted_array.append(big_boy, big_boy_weight)
	
	var enemy = weighted_array.pop_random()
	
	# Free unused enemies
	for item in weighted_array.array:
		item[0].free()
		
	return enemy
