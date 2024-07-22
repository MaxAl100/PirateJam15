extends CharacterBody2D

@export var Speed = 80.0
@export var Bullets: Array[PackedScene] = []
var timesForBullets: Array[float] = []
@export var Health = 100.0
@export var MaxInvincibilityTime = 0.4
var CurrentInvincibilityTime = 0

func _ready():
	timesForBullets.resize(Bullets.size())
	for i in range(Bullets.size()):
		var bullet_instance = Bullets[i].instantiate()
		timesForBullets[i] = bullet_instance.maxTimeBetweenAttacks

func _physics_process(delta):
	velocity = Vector2.ZERO  # Use Vector2.ZERO to reset velocity

	if Input.is_action_pressed("move_down"):
		velocity.y += Speed
	if Input.is_action_pressed("move_up"):
		velocity.y -= Speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= Speed
	if Input.is_action_pressed("move_right"):
		velocity.x += Speed

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
	var damage = collision.get_collider().Damage
	if CurrentInvincibilityTime <= 0:
		CurrentInvincibilityTime = MaxInvincibilityTime
		Health -= damage

func _shoot_bullet(bullet_scene):
	var newBullet = bullet_scene.instantiate()
	var all_enemies = get_tree().get_nodes_in_group("enemies")
	
	var closest_enemy = all_enemies[0]
	for enemy in all_enemies:
		if position.distance_to(enemy.position) < position.distance_to(closest_enemy.position):
			closest_enemy = enemy

	if newBullet.target == "nearest enemy" && all_enemies.size > 0:
		newBullet.direction = (closest_enemy.position - position).normalized()
		newBullet.position = $"Bullet Origin".position 
		add_child(newBullet)  

