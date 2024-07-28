extends Area2D

var speed = 180

var damage = 22
var amount = 1
var maxTimeBetweenAttacks = 18
var currentTimeBetweenAttacks = 1
var attackLength = 4
var target = "nearest enemy"
var direction = Vector2.ZERO
var knockback = -20

var burn_value = 30

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))

func _physics_process(delta):
	position += direction * speed * delta
	attackLength -= delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body._recieve_damage(self)
		body.SlowDownEffect = 0.2
	if attackLength <= 0:
		queue_free()

func set_direction_and_rotate(dir):
	self.direction = dir
	rotation = dir.angle()
