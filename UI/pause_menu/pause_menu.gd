extends Control


@onready var restart_button : SoundButton = %RestartButton
@onready var main_menu_button : SoundButton = %MainMenuButton
@onready var quit_button : SoundButton = %QuitButton
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var scene_to_load : String

func _ready() -> void:
	#restart_button.pressed.connect(_restart)
	#main_menu_button.pressed.connect(_main_menu)
	restart_button.pressed.connect(fade_out.bind("res://game_assets/level/main_level.tscn"))
	main_menu_button.pressed.connect(fade_out.bind("res://UI/main_menu/main_menu.tscn"))
	quit_button.pressed.connect(_quit)
	
func _input(event: InputEvent) -> void:
	if PlayerStats.HP == 0:
		return
	
	
	if event.is_action_pressed("ui_cancel") and not get_tree().paused:
		print("Game paused")
		self.show()
		get_tree().paused = true
	
	elif event.is_action_pressed("ui_cancel") and get_tree().paused:
		print("Unpause")
		self.hide()
		get_tree().paused = false
		
#func _restart():
	#GameManager.end_game()
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://game_assets/level/main_level.tscn")
	#
#func _main_menu():
	#GameManager.end_game()
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://UI/main_menu/main_menu.tscn")

func fade_out(s : String):
	scene_to_load = s
	animation_player.play("fade_out")

func _load_scene():
	GameManager.end_game()
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_to_load)

func _quit():
	get_tree().quit()
