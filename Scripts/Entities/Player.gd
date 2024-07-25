extends CharacterBody2D

@export var Speed = 40.0
@export var Bullets: Array[PackedScene] = []
var TimesForBullets: Array[float] = []
var BulletContainer
var TurningCounter = {}

var CurrentSpell = 0
var AllSpellInfo: Array[String] = []
var SpellText
@export var TotalTimeToBurn = 3
var currentTimeToBurn = 3

@export var Health = 300.0
@export var DecreaseStrength = 1.0
@export var Light: PointLight2D

@export var MaxInvincibilityTime = 0.8
var CurrentInvincibilityTime = 0
var damage = 0

@export var KnockbackStrength = 20.0

var _last_direction = Vector2.RIGHT

func _ready():
	resize_lists()
	SpellText = $"Symbol Holder/Current Spell Info"
	SpellText.text = AllSpellInfo[CurrentSpell]
	print(get_tree().root.get_node("BaseLevel/BulletContainer"))
	BulletContainer = get_tree().root.get_node("BaseLevel/BulletContainer")

func _physics_process(delta):
	Health -= delta * DecreaseStrength
	Light.scale = Vector2(Health/100, Health/100)
	
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
	
	if Input.is_action_just_pressed("next_rune"):
		change_selected(true)
	elif Input.is_action_just_pressed("prev_rune"):
		change_selected(false)
	
	if Input.is_action_pressed("burn_rune"):
		currentTimeToBurn -= delta
		if currentTimeToBurn < 0:
			remove_bullet(CurrentSpell)
			currentTimeToBurn = TotalTimeToBurn
	if Input.is_action_just_released("burn_rune"):
		currentTimeToBurn = TotalTimeToBurn
		

	CurrentInvincibilityTime -= delta

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collision_name = collision.get_collider().name
		if "Enemy" in collision_name:
			_recieve_damage(collision)

	for i in range(TimesForBullets.size()):
		TimesForBullets[i] -= delta
		if TimesForBullets[i] <= 0:
			_shoot_bullet(Bullets[i], i)
			var bullet_instance = Bullets[i].instantiate()
			TimesForBullets[i] = bullet_instance.maxTimeBetweenAttacks

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

func _shoot_bullet(bullet_scene, pos):
	var newBullet = bullet_scene.instantiate()
	var all_enemies = get_tree().get_nodes_in_group("enemies")

	if newBullet.target == "nearest enemy" && all_enemies.size() > 0:
		var closest_enemy = all_enemies[0]
		for enemy in all_enemies:
			if position.distance_to(enemy.position) < position.distance_to(closest_enemy.position):
				closest_enemy = enemy
		var direction = (closest_enemy.position - position).normalized()
		newBullet.set_direction_and_rotate(direction)
		BulletContainer.add_child(newBullet)
		newBullet.position = self.position

	
	elif newBullet.target == "self":
		newBullet.position = $"Bullet Origin".position
		add_child(newBullet)
		
	elif newBullet.target == "looking side":
		newBullet.set_direction_and_rotate(_last_direction)
		newBullet.position = $"Bullet Origin".position
		add_child(newBullet)
	
	elif newBullet.target == "turning":
		var direction = Vector2(0,1).rotated(deg_to_rad(45*TurningCounter[pos]))
		TurningCounter[pos] = (TurningCounter[pos] + 1)%8
		newBullet.set_direction_and_rotate(direction)
		BulletContainer.add_child(newBullet)
		newBullet.position = self.position

func remove_bullet(pos):
	if Bullets.size() <= 1:
		return
	
	if pos <= CurrentSpell:
		if CurrentSpell == 0:
			CurrentSpell = 0  
		else:
			CurrentSpell -= 1
	
	Health += Bullets[pos].instantiate().burn_value
	Bullets.remove_at(pos)
	
	resize_lists()
	
	if Bullets.size() > 0:
		SpellText.text = AllSpellInfo[CurrentSpell]
	else:
		SpellText.text = "No Spells Available"

func add_bullet(bullet):
	Bullets.append(bullet)
	resize_lists()

func resize_lists():
	var oldCounter = TurningCounter
	TurningCounter.clear()
	TimesForBullets.resize(Bullets.size())
	AllSpellInfo.resize(Bullets.size())
	for i in range(Bullets.size()):
		var bullet_instance = Bullets[i].instantiate()
		TimesForBullets[i] = bullet_instance.currentTimeBetweenAttacks
		AllSpellInfo[i] = bullet_instance.name
		if bullet_instance.target == "turning":
			if oldCounter.has(i):
				TurningCounter[i] = oldCounter[i]
			else:
				TurningCounter[i] = 0

func change_selected(next):
	if next:
		CurrentSpell = (CurrentSpell + 1) % Bullets.size()
	else:
		CurrentSpell = (CurrentSpell - 1) % Bullets.size()
		if CurrentSpell < 0:
			CurrentSpell = Bullets.size() - 1
	
	if Bullets.size() > 0:
		SpellText.text = AllSpellInfo[CurrentSpell]
