extends CharacterBody2D

@export var Damage = 10
@export var Speed = 50.0
@export var Health = 8.0

var Player
var Direction

func _ready():
	Player = get_parent().get_parent().get_node("Player")
	self.add_to_group("enemies")


func _physics_process(delta):
	Direction = (Player.position - self.position).normalized()
	velocity = Direction * Speed
	move_and_slide()

func _recieve_damage(damage):
	Health -= damage
	if Health <= 0:
		self.queue_free()