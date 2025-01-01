class_name Mirror
extends Node2D

@onready var hitbox : Area2D = $Hitbox
@onready var deflect_sfx : AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var powerup_sfx : AudioStreamPlayer = $FullyCharged

var direction = Vector2.ZERO
var charge : int:
	set(new_charge):
		if new_charge == 3 and charge != 3:
			powerup_sfx.play()
			
		charge = clamp(new_charge, 0, 3)
		var a = 1 + 0.3 * charge
		sprite.modulate = Color(a,a,a)
		
		if new_charge > 0:
			PlayerStats.mirror_charged.emit()
		

func _ready() -> void:
	hitbox.area_entered.connect(deflect)
	#modulate = Color.GRAY
	hitbox.monitoring = true
	
func deflect(area : Area2D) -> void:
	var parent = area.get_parent()
	if parent is Projectile:
		if not parent.is_big or (parent.is_big and charge == 3):
			parent.get_mirrored(PlayerStats.mouse_direction, charge)
			if charge == 3:
				parent.damage *= 2
			
			deflect_sfx.play()
			particles.lifetime = 0.1 * charge
			var a = 1 + 0.3 * charge
			particles.modulate = Color(a,a,a)
			animation_player.play("deflect")
			charge = 0
			GameManager.reflected_projectile.emit()
			if parent.is_big:
				GameManager.reflected_big_projectile.emit()

func disable():
	# Disable wen player dies
	hitbox.monitoring = false
	hide()
