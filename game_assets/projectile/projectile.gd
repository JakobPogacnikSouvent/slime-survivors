class_name Projectile
extends CharacterBody2D

@export var SPEED : int = 3000
@export var damage : int = 1

var direction = Vector2(1,0):
	set(new_direction):
		direction = new_direction.normalized()
		var a = new_direction.angle()
		rotation = a
		

var collision_area : Area2D
var sprite : AnimatedSprite2D

var frame : int = 0
var is_big : int = false

func _ready() -> void:	
	if is_big:
		$SmallSprite.hide()
		$SmallArea/CollisionShape2D.disabled = true
		collision_area = $BigArea
		sprite = $BigSprite
		damage = 2
	else:
		$BigSprite.hide()
		$BigArea/CollisionShape2D.disabled = true
		collision_area = $SmallArea
		sprite = $SmallSprite
		
	collision_area.body_entered.connect(hit_someting)
	sprite.frame = frame


func _physics_process(delta: float) -> void:
	velocity = direction * SPEED * delta
	move_and_slide()


func get_mirrored(mirror_direction : Vector2, mirror_charge : int) -> void:
	sprite.frame = 1
	direction = mirror_direction
	
	var proj = PlayerStats.velocity.dot(direction)
	SPEED += 20*proj + mirror_charge * 2000 * int(not is_big)
	
	
	collision_area.set_collision_layer_value(2, false)
	collision_area.set_collision_layer_value(3, true)
	collision_area.set_collision_mask_value(2, false)
	collision_area.set_collision_mask_value(3, true)


func hit_someting(body : Node2D) -> void:
	if body is Player:
		PlayerStats.take_damage(damage)
		body.dmg_animation(direction)
	elif body is AbstractEnemy:
		body.take_damage(damage, direction)

	# Call queue_free in parent after they take damage.
	# Need bullet direction for damage
	queue_free()
