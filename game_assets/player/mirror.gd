class_name Mirror
extends Sprite2D

@onready var hitbox : Area2D = $Hitbox
@onready var deflect_sfx : AudioStreamPlayer = $AudioStreamPlayer

var direction = Vector2.ZERO

func _ready() -> void:
	hitbox.area_entered.connect(deflect)
	#modulate = Color.GRAY
	hitbox.monitoring = true

#func attack(attack_direction : Vector2) -> void:
	#direction = attack_direction
	#hitbox.monitoring = true
	#modulate = Color.WHITE
	#await get_tree().create_timer(0.05).timeout
	#hitbox.monitoring = false
	#modulate = Color.GRAY
	
func deflect(area : Area2D) -> void:
	var parent = area.get_parent()
	deflect_sfx.play()
	if parent is Projectile:
		parent.get_mirrored(PlayerStats.mouse_direction)
