extends Area2D

var speed = 400

var damage = 14
var amount = 1
var maxTimeBetweenAttacks = 10
var startingTimeGenerator = RandomNumberGenerator.new()
var currentTimeBetweenAttacks = startingTimeGenerator.randi_range(1,5)
var attackLength = 99
var target = "nearest enemy"
var direction = Vector2.ZERO
var knockback = -25

var burn_value = 10

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))

func _physics_process(delta):
	position += direction * speed * delta

func _on_Bullet_body_entered(body):
	if body.name == "Player":
		return
	if body.is_in_group("enemies"):
		body._recieve_damage(self)
	queue_free()

func set_direction_and_rotate(dir):
	self.direction = dir
	rotation = dir.angle()

