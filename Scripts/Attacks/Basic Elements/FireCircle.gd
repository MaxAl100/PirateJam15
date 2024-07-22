extends Area2D

var damage = 3
var amount = 1
var knockback = 10
var maxTimeBetweenAttacks = 30
var currentTimeBetweenAttacks = 1
var attackLength = 5
var target = "self"

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))


func _physics_process(delta):
	attackLength -= delta
	if attackLength <= 0:
		queue_free()

func _on_Bullet_body_entered(body):
	if body.name == "Player":
		return
	if body.is_in_group("enemies"):
		body._recieve_damage(self)
