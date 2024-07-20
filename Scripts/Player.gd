extends CharacterBody2D

@export var Speed = 50.0


@export var Health = 100.0
@export var MaxInvincibilityTime = 250
var CurrentInvincibilityTime


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
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var name = collision.get_collider().name
		#print("I collided with ", name)
		if "Enemy" in name:
			_recieve_damage()

func _recieve_damage():
	print("I recieved damage!")
