extends Control

@onready var heart_1 : TextureRect = $HBoxContainer/TextureRect
@onready var heart_2 : TextureRect = $HBoxContainer/TextureRect2
@onready var heart_3 : TextureRect = $HBoxContainer/TextureRect3


func _ready() -> void:
	PlayerStats.player_hp_changed.connect(update_damage)


func update_damage() -> void:
	var hp = PlayerStats.HP
	match hp:
		0:
			heart_1.modulate.a8 = 30
			heart_2.modulate.a8 = 30
			heart_3.modulate.a8 = 30
		1:
			heart_1.modulate.a8 = 255
			heart_2.modulate.a8 = 30
			heart_3.modulate.a8 = 30
		2:
			heart_1.modulate.a8 = 255
			heart_2.modulate.a8 = 255
			heart_3.modulate.a8 = 30
		_:
			heart_1.modulate.a8 = 255
			heart_2.modulate.a8 = 255
			heart_3.modulate.a8 = 255
