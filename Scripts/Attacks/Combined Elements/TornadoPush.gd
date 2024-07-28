extends Area2D

var speed = 50
var pull_strength = 100
var rotation_speed = 1000

var damage = 10
var amount = 1
var maxTimeBetweenAttacks = 15
var currentTimeBetweenAttacks = 1
var attackLength = 5
var target = "nearest enemy"
var direction = Vector2.ZERO
var knockback = 0

var burn_value = 30

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))
	connect("body_exited", Callable(self, "_on_Bullet_body_exited"))

func _physics_process(delta):
	position += direction * speed * delta
	rotation_degrees += delta * rotation_speed
	rotation_degrees = fmod(rotation_degrees,360.0)
	attackLength -= delta
	if attackLength <= 0:
		queue_free()

func _process(delta):
	for body in get_overlapping_bodies():
		if body.has_meta("being_pulled") and body.get_meta("being_pulled"):
			body.apply_pull_force(position, pull_strength, delta)

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body._recieve_damage(self)
		body.set_meta("being_pulled", true)  

func _on_Bullet_body_exited(body):
	if body.is_in_group("enemies"):
		body.set_meta("being_pulled", false) 
 
func set_direction_and_rotate(dir):
	self.direction = dir
	rotation = dir.angle()
