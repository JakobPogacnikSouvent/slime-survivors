class_name BasicEnemy
extends AbstractEnemy

@onready var sprite : AnimatedSprite2D = $Sprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super()
	
	var level = GameManager.level
	speed += 100 * level
	score += 10 * level
	
	spawning_weight = max(spawning_weight - 0.2 * (level - 1), 0.1)


func _physics_process(delta: float) -> void:
	if PlayerStats.HP == 0:
		return
	
	var direction = to_local(PlayerStats.player_global_position).normalized()
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
	var projectile = projectile_tsc.instantiate()
	projectile.position = position
	projectile.direction = to_local(PlayerStats.player_global_position).normalized()
	
	projectile.SPEED = max(projectile.SPEED, speed + 1500)
	
	get_parent().add_child(projectile)

func die(direction : Vector2) -> void:
	super(direction)
	speed = 0
	$Label.text = "+" + str(score)
	$CPUParticles2D.direction = direction
	self.set_collision_layer_value(1, false)
	self.set_collision_layer_value(3, false)
	
	is_in_death_animation = true
	$AnimationPlayer.play("die")
