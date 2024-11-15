class_name Projectile
extends CharacterBody2D

@export var SPEED : int = 3000
@export var damage : int = 1

var direction = Vector2(1,0):
	set(new_direction):
		direction = new_direction
		var a = new_direction.angle()
		rotation = a
		

@onready var collision_area : Area2D = $Area2D


func _ready() -> void:
	collision_area.body_entered.connect(hit_someting)


func _physics_process(delta: float) -> void:
	velocity = direction * SPEED * delta
	move_and_slide()


func get_mirrored(mirror_direction : Vector2) -> void:
	modulate = Color.BLACK
	direction = mirror_direction
	collision_area.set_collision_layer_value(2, false)
	collision_area.set_collision_layer_value(3, true)
	collision_area.set_collision_mask_value(2, false)
	collision_area.set_collision_mask_value(3, true)


func hit_someting(body : Node2D) -> void:
	if body is Player:
		PlayerStats.take_damage(damage)
	elif body is AbstractEnemy:
		body.take_damage(damage, direction)

	# Call queue_free in parent after they take damage.
	# Need bullet direction for damage
	queue_free()
