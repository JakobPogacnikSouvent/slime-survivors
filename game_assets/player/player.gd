class_name Player
extends CharacterBody2D

@export var SPEED : int = 2000
@export var DASH_SPEED : int = 20000

@onready var mirror : Mirror = $Mirror
@onready var hitbox : Area2D = $Hitbox
@onready var dash_timer : Timer = $DashTimer
@onready var dash_cooldown : Timer = $DashCooldown
@onready var collision_box : CollisionShape2D = $CollisionBox

var dashing : bool = false
var dashing_direction : Vector2


func _ready() -> void:
	dash_timer.timeout.connect(_end_dash)

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("attack"):
		#mirror.attack(mouse_direction)
		
	var dash_on_cd : bool = dash_cooldown.time_left > 0
	if event.is_action_pressed("dash") and not dashing and not dash_on_cd:
		dashing = true
		dashing_direction = PlayerStats.mouse_direction
		dash_timer.one_shot = true
		dash_timer.start(0.1)
		collision_box.disabled = true


func _physics_process(delta: float) -> void:
	var direction
	if not dashing:
		direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
		direction = direction.normalized()
		velocity = direction * SPEED * delta
	else:
		direction = dashing_direction.normalized()
		velocity = direction * DASH_SPEED * delta
		
	move_and_slide()
	
	PlayerStats.player_global_position = global_position
	

func _process(delta: float) -> void:
	PlayerStats.mouse_direction = get_local_mouse_position().normalized()
	var norm = Vector2(0, -1)
	var a = PlayerStats.mouse_direction.angle_to(norm)
	mirror.rotation = -a
	

func level_up() -> void:
	pass


func _end_dash() -> void:
	dashing = false
	collision_box.disabled = false
	dash_cooldown.start(0.5)
