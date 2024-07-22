extends Area2D

var speed = 400
var damage = 8
var amount = 1
var maxTimeBetweenAttacks = 15
var currentTimeBetweenAttacks = 15
var target = "nearest enemy"
var direction = Vector2.ZERO

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))


func _physics_process(delta):
	position += direction * speed * delta

func _on_Bullet_body_entered(body):
	if body.name == "Player":
		return
	if body.is_in_group("enemies"):
		body._recieve_damage(damage)
	queue_free()

