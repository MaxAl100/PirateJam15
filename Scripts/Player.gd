extends CharacterBody2D

@export var Speed = 80.0


@export var Health = 100.0
@export var MaxInvincibilityTime = 0.4
var CurrentInvincibilityTime = 0


func _physics_process(delta):
	velocity.y = 0
	velocity.x = 0
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
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var name = collision.get_collider().name
		#print("I collided with ", name)
		if "Enemy" in name:
			_recieve_damage(collision)

func _recieve_damage(collision):
	var damage = collision.get_collider().Damage
	if CurrentInvincibilityTime <= 0:
		CurrentInvincibilityTime = MaxInvincibilityTime
		Health -= damage
