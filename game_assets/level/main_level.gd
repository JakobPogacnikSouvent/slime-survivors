class_name Level
extends Node2D

@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var tutorial : TutorialMenu = $CanvasLayer/TutorialMenu
@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	PlayerStats.player_died.connect(end_game)
	
	if not GameManager.show_tutorial:
		tutorial.hide()
	
	animation_player.play("fade_in")
	GameManager.start_game(self)
	
func end_game():
	GameManager.end_game()
	audio.pitch_scale = 0.8
	animation_player.play("end_game")

func pause():
	get_tree().paused = true
	
