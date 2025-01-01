class_name DeathMenu
extends Control


@onready var score_n : Label = %ScoreN
@onready var kills_n : Label = %KillsN
@onready var level_n : Label = %LevelN
@onready var animation_player : AnimationPlayer = $AnimationPlayer


@onready var restart_button : SoundButton = %RestartButton
@onready var main_menu_button : SoundButton = %MainMenuButton
@onready var quit_button : SoundButton = %QuitButton
 
var scene_to_load : String

func _ready() -> void:
	score_n.hide()
	kills_n.hide()
	level_n.hide()
	
	restart_button.pressed.connect(fade_out.bind("res://game_assets/level/main_level.tscn"))
	main_menu_button.pressed.connect(fade_out.bind("res://UI/main_menu/main_menu.tscn"))
	
	quit_button.pressed.connect(_quit)

func appear():
	self.show()
	score_n.text = str(GameManager.score)
	kills_n.text = str(GameManager.kills)
	level_n.text = str(GameManager.level)
	
	animation_player.play("appear")
#
#func _restart():
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://game_assets/level/main_level.tscn")
#
#func _main_menu():
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://UI/main_menu/main_menu.tscn")

func fade_out(s : String):
	print("Fading out")
	scene_to_load = s
	$ColorRect.mouse_filter = 0
	animation_player.play("fade_out")

func _load_scene():
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_to_load)

func _quit():
	get_tree().quit()
