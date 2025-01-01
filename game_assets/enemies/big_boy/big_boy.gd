class_name BigBoy
extends AbstractEnemy

@onready var sprite : AnimatedSprite2D = $Sprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var particles : CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	super()
	
	var level = GameManager.level
	speed += 100 * level
	score += 100 * level
	spawning_weight = min(0.2 * (level - 2), 1)
	max_hp += level/10
	hp = max_hp


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

func take_damage(dmg : int, direction : Vector2) -> void:
	hp -= dmg
	if hp == 0:
		die(direction)
	else:
		particles.direction = direction
		animation_player.play("take_damage")

func spawn_projectile() -> void:
	var projectile : Projectile = projectile_tsc.instantiate()
	projectile.position = position
	projectile.is_big = true
	projectile.direction = to_local(PlayerStats.player_global_position).normalized()
	projectile.SPEED = max(projectile.SPEED, speed + 1500)
	
	get_parent().add_child(projectile)

func die(direction : Vector2) -> void:
	super(direction)
	speed = 0
	$Label.text = "+" + str(score)
	particles.direction = direction
	self.set_collision_layer_value(1, false)
	self.set_collision_layer_value(3, false)
	
	is_in_death_animation = true
	animation_player.play("die")
