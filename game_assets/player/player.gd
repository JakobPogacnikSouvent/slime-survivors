class_name Player
extends CharacterBody2D

@export var SPEED : int = 2000
@export var DASH_SPEED : int = 20000

@onready var sprite : AnimatedSprite2D = $Player
@onready var mirror : Mirror = $Mirror
@onready var dash_timer : Timer = $DashTimer
@onready var dash_cooldown : Timer = $DashCooldown
@onready var collision_box : CollisionShape2D = $CollisionBox
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var idle_animation_player : Timer = $IdleAnimation
@onready var particles : CPUParticles2D = $CPUParticles2D

var dashing : bool = false
var dashing_direction : Vector2

var charge : int = 0

func _ready() -> void:
	dash_timer.timeout.connect(_end_dash)
	idle_animation_player.timeout.connect(_random_idle)
	idle_animation_player.start()
	

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("attack"):
		#mirror.attack(mouse_direction)
		
	var dash_on_cd : bool = dash_cooldown.time_left > 0
	if event.is_action_pressed("dash") and not dashing and not dash_on_cd:
		_enter_dash()


func _physics_process(delta: float) -> void:
	if PlayerStats.HP == 0:
		return
		
	var direction : Vector2
	if not dashing:
		direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
		direction = direction.normalized()
		velocity = direction * SPEED * delta
		if direction:
			PlayerStats.player_moved.emit()
	else:
		direction = dashing_direction.normalized()
		velocity = direction * DASH_SPEED * delta
		PlayerStats.player_dashed.emit()
	
	var x = Vector2(1,0)
	var proj = (direction.dot(x) * x).normalized()
	match proj:
		Vector2(1,0):
			sprite.flip_h = true
		Vector2(-1,0):
			sprite.flip_h = false
			
	PlayerStats.velocity = velocity
	move_and_slide()
	
	PlayerStats.player_global_position = global_position
	

func _process(delta: float) -> void:
	PlayerStats.mouse_direction = get_local_mouse_position().normalized()
	var norm = Vector2(0, -1)
	var curr_mirror = norm.rotated(mirror.rotation)
	var b = curr_mirror.angle_to(PlayerStats.mouse_direction)
	mirror.rotation += b
	
	if mirror.rotation > 2*PI:
		mirror.rotation -= 2*PI
		mirror.charge += 1
	elif mirror.rotation < -2*PI:
		mirror.rotation += 2*PI
		mirror.charge += 1

func level_up() -> void:
	pass

	
func dmg_animation(direction : Vector2) -> void:
	particles.direction = direction
	
	if PlayerStats.HP == 0:
		particles.lifetime = 1
		sprite.hide()
		mirror.disable()
	
	animation_player.play("take_dmg")


func _enter_dash() -> void:
	var moving_direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	if not moving_direction:
		return
	
	dashing = true
	#dashing_direction = PlayerStats.mouse_direction
	dashing_direction = moving_direction
	dash_timer.one_shot = true
	dash_timer.start(0.1)
	collision_box.disabled = true
	animation_player.play("enter_dash")


func _end_dash() -> void:
	dashing = false
	collision_box.disabled = false
	dash_cooldown.start(0.5)
	animation_player.play("exit_dash")


func _random_idle() -> void:
	animation_player.play("idle_1")
