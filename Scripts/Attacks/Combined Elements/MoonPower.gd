extends Area2D

var damage = 3
var amount = 1
var maxTimeBetweenAttacks = 2
var currentTimeBetweenAttacks = 2
var attackLength = 1
var target = "turning"
var direction = Vector2.ZERO
var knockback = -20


var burn_value = 10

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))


func _physics_process(delta):
	attackLength -= delta
	if attackLength <= 0:
		queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body._recieve_damage(self)

func set_direction_and_rotate(dir):
	self.direction = dir
	rotation = dir.angle()
