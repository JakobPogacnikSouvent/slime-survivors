extends Control

@onready var start_button = %StartButton
@onready var settings_button = %SoundButton
@onready var tutorial_checkbox = %CheckBox
@onready var quit_button : SoundButton = %QuitButton
@onready var high_score_label : Label = %HighScoreLabel
@onready var settings_menu = $SettingsMenu
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(start_game)
	tutorial_checkbox.button_pressed = GameManager.show_tutorial
	tutorial_checkbox.toggled.connect(_checkbox_toggled)
	
	high_score_label.text = "High Score: " + str(GameManager.high_score)
	
	quit_button.pressed.connect(quit_game)
	settings_button.pressed.connect(show_settings)
	
	animation_player.play("fade_in")
	
func start_game() -> void:
	animation_player.play("fade_out")

func _load_game() -> void:
	get_tree().change_scene_to_file("res://game_assets/level/main_level.tscn")
	

func _checkbox_toggled(b : bool):
	GameManager.show_tutorial = b

func quit_game():
	get_tree().quit()

func show_settings():
	settings_menu.show()
