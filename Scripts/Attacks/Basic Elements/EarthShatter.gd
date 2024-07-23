extends Area2D

var damage = 8
var knockback = 60
var amount = 1
var maxTimeBetweenAttacks = 28
var currentTimeBetweenAttacks = 1
var attackLength = 0.12
var target = "nearest enemy"
var direction = Vector2.ZERO

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

func set_direction_and_rotate(direction):
	self.direction = direction
	rotation = direction.angle()