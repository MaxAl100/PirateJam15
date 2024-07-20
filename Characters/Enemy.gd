extends CharacterBody2D

@export var Damage = 10
@export var Speed = 50.0

var Player
var Direction

func _ready():
	Player = get_parent().get_node("Player")


func _physics_process(delta):
	Direction = (Player.position - self.position).normalized()
	velocity = Direction * Speed
	move_and_slide()
