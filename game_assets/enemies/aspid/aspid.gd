class_name Aspid
extends AbstractEnemy

@onready var sprite : AnimatedSprite2D = $Sprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()
	
	var level = GameManager.level
	speed += 200 * level
	score += 50 * level
	spawning_weight = min(0.2 * level, 1)

func _physics_process(delta: float) -> void:
	if PlayerStats.HP == 0:
		return
	
	var direction = to_local(PlayerStats.player_global_position).normalized()
	direction += direction.rotated(PI/2)
	velocity = direction * speed * delta
	
	var x = Vector2(1,0)
	var proj = (direction.dot(x) * x).normalized()
	match proj:
		Vector2(1,0):
			sprite.flip_h = true
		Vector2(-1,0):
			sprite.flip_h = false
			
	move_and_slide()


func attack() -> void:
	super()
	
	if is_off_screen() or is_in_death_animation:
		return
	animation_player.play("shoot")
	
	

func spawn_projectile() -> void:
	var projectile1 = projectile_tsc.instantiate()
	var projectile2 = projectile_tsc.instantiate()
	var projectile3 = projectile_tsc.instantiate()
	
	projectile1.position = position
	projectile2.position = position
	projectile3.position = position
	
	var direction = to_local(PlayerStats.player_global_position).normalized()
	
	projectile1.direction = direction
	projectile2.direction = direction.rotated(PI/4)
	projectile3.direction = direction.rotated(-PI/4)
	
	projectile1.frame = 2
	projectile2.frame = 2
	projectile3.frame = 2
	
	projectile1.SPEED = max(projectile1.SPEED, speed + 1500)
	projectile2.SPEED = max(projectile2.SPEED, speed + 1500)
	projectile3.SPEED = max(projectile3.SPEED, speed + 1500)
	
	get_parent().add_child(projectile1)
	get_parent().add_child(projectile2)
	get_parent().add_child(projectile3)

func die(direction : Vector2) -> void:
	super(direction)
	speed = 0
	$Label.text = "+" + str(score)
	$CPUParticles2D.direction = direction
	self.set_collision_layer_value(1, false)
	self.set_collision_layer_value(3, false)
	
	is_in_death_animation = true
	$AnimationPlayer.play("die")
