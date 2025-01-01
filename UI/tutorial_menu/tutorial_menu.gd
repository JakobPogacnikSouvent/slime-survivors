class_name TutorialMenu
extends Control


@onready var move_label : Label = $Panel/MarginContainer/MoveLabel
@onready var dash_label : Label = $Panel/MarginContainer/DashLabel
@onready var reflect_label : Label =$Panel/MarginContainer/ReflectLabel
@onready var kill_label : Label =$Panel/MarginContainer/KillLabel
@onready var charge_label : Label =$Panel/MarginContainer/ChargeLabel
@onready var reflect_label_2 : Label =$Panel/MarginContainer/ReflectLabel2
@onready var final_label : Label =$Panel/MarginContainer/FinalLabel

@onready var final_timer : Timer = $Timer

var curr_tutorial
enum tutorials {
	MOVE,
	DASH,
	REFLECT,
	KILL,
	CHARGE,
	REFLECT2,
	FINAL,
	OVER
}

func _ready() -> void:
	curr_tutorial = tutorials.MOVE
	update_label()
	
	PlayerStats.player_moved.connect(finish_tutorial.bind(tutorials.MOVE, tutorials.DASH))
	PlayerStats.player_dashed.connect(finish_tutorial.bind(tutorials.DASH, tutorials.REFLECT))
	GameManager.reflected_projectile.connect(finish_tutorial.bind(tutorials.REFLECT, tutorials.KILL))
	GameManager.killed_enemy.connect(finish_tutorial.bind(tutorials.KILL, tutorials.CHARGE))
	PlayerStats.mirror_charged.connect(finish_tutorial.bind(tutorials.CHARGE, tutorials.REFLECT2))
	GameManager.reflected_big_projectile.connect(finish_tutorial.bind(tutorials.REFLECT2, tutorials.FINAL))
	final_timer.timeout.connect(finish_tutorial.bind(tutorials.FINAL, tutorials.OVER))
	
func update_label():
	hide_labels()
	match curr_tutorial:
		tutorials.MOVE:
			move_label.show()
		tutorials.DASH:
			dash_label.show()
		tutorials.REFLECT:
			reflect_label.show()
		tutorials.KILL:
			kill_label.show()
		tutorials.CHARGE:
			charge_label.show()
		tutorials.REFLECT2:
			reflect_label_2.show()
		tutorials.FINAL:
			final_label.show()
			final_timer.start(20)
		tutorials.OVER:
			GameManager.show_tutorial = false
			self.hide()


func finish_tutorial(finished_tutorial : int, next_tutorial : int):
	if curr_tutorial == finished_tutorial:
		curr_tutorial = next_tutorial
		update_label()

func hide_labels():
	move_label.hide()
	dash_label.hide()
	reflect_label.hide()
	kill_label.hide()
	charge_label.hide()
	reflect_label_2.hide()
	final_label.hide()
