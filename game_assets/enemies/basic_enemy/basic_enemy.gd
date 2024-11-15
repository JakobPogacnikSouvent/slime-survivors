class_name BasicEnemy
extends AbstractEnemy


func _ready() -> void:
	super()
	
	var level = GameManager.level
	speed += 100 * level
	score += 10 * level


func _physics_process(delta: float) -> void:
	var direction = to_local(PlayerStats.player_global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()


func attack() -> void:
	super()
	
	if is_off_screen() or is_in_death_animation:
		return
	
	var projectile = projectile_tsc.instantiate()
	projectile.position = position
	projectile.direction = to_local(PlayerStats.player_global_position).normalized()
	
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
