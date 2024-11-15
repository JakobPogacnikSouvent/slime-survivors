extends Control


@onready var start_button = %StartButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(start_game)
	
func start_game() -> void:
	get_tree().change_scene_to_file("res://game_assets/level/main_level.tscn")
