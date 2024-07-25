extends Area2D

var speed = 160
var AnimPlayer: AnimationPlayer
var active = false

var damage = 30
var amount = 1
var maxTimeBetweenAttacks = 21
var currentTimeBetweenAttacks = 1
var attackLength = 99
var target = "nearest enemy"
var direction = Vector2.ZERO
var knockback = -25

var burn_value = 10

func _ready():
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))
	AnimPlayer = $AnimationPlayer

func _physics_process(delta):
	position += direction * speed * delta
	self.attackLength -= delta
	if attackLength < 0:
		queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemies"):
		body._recieve_damage(self)
		if not active:
			activate()

func set_direction_and_rotate(direction):
	self.direction = direction
	rotation = direction.angle()

func activate():
	active = true
	self.attackLength = 0.2
	self.direction = Vector2(0,0)
	AnimPlayer.play("LavaExplosion",-1,1.0,false)
