extends Area2D

var damage = 3
var amount = 1
var maxTimeBetweenAttacks = 8
var currentTimeBetweenAttacks = 1
var attackLength = 10
var target = "self"
var knockback = -2

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