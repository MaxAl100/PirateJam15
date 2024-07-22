extends CharacterBody2D

@export var Speed = 40.0
@export var Bullets: Array[PackedScene] = []
var timesForBullets: Array[float] = []
@export var Health = 100.0
@export var MaxInvincibilityTime = 0.8
var CurrentInvincibilityTime = 0
var damage = 0

@export var KnockbackStrength = 20.0

var _last_direction = Vector2.RIGHT

func _ready():
	timesForBullets.resize(Bullets.size())
	for i in range(Bullets.size()):
		var bullet_instance = Bullets[i].instantiate()
		timesForBullets[i] = bullet_instance.currentTimeBetweenAttacks

func _physics_process(delta):
	velocity = Vector2.ZERO

	if Input.is_action_pressed("move_down"):
		velocity.y += Speed
	if Input.is_action_pressed("move_up"):
		velocity.y -= Speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= Speed
		_last_direction = Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		velocity.x += Speed
		_last_direction = Vector2.RIGHT

	move_and_slide()

	CurrentInvincibilityTime -= delta

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collision_name = collision.get_collider().name
		if "Enemy" in collision_name:
			_recieve_damage(collision)

	for i in range(timesForBullets.size()):
		timesForBullets[i] -= delta
		if timesForBullets[i] <= 0:
			_shoot_bullet(Bullets[i])
			var bullet_instance = Bullets[i].instantiate()
			timesForBullets[i] = bullet_instance.maxTimeBetweenAttacks

func _recieve_damage(collision):
	if CurrentInvincibilityTime > 0:
		return
	CurrentInvincibilityTime = MaxInvincibilityTime
	var collider = collision.get_collider()
	if collider.has_method("get_damage"):
		var coll_damage = collider.get_damage()
		if CurrentInvincibilityTime > 0:
			return
		CurrentInvincibilityTime = MaxInvincibilityTime
		Health -= coll_damage

		if Health <= 0:
			self.queue_free()
			get_tree().reload_scene()
		else:
			_apply_knockback(collision)

func _apply_knockback(collision):
	var collider = collision.get_collider()
	var knockback_direction = (position - collider.position).normalized()
	velocity += knockback_direction * KnockbackStrength

func _shoot_bullet(bullet_scene):
	var newBullet = bullet_scene.instantiate()
	var all_enemies = get_tree().get_nodes_in_group("enemies")

	if newBullet.target == "nearest enemy" && all_enemies.size() > 0:
		var closest_enemy = all_enemies[0]
		for enemy in all_enemies:
			if position.distance_to(enemy.position) < position.distance_to(closest_enemy.position):
				closest_enemy = enemy
		var direction = (closest_enemy.position - position).normalized()
		newBullet.position = $"Bullet Origin".position
		newBullet.set_direction_and_rotate(direction)
		add_child(newBullet)
	
	elif newBullet.target == "self":
		newBullet.position = $"Bullet Origin".position
		add_child(newBullet)
		
	elif newBullet.target == "looking side":
		newBullet.set_direction_and_rotate(_last_direction)
		newBullet.position = $"Bullet Origin".position
		add_child(newBullet)
