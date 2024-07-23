extends Area2D

@export var size = 1.0
@export var decreaseSpeed = 0.00004


func _ready():
	pass


func _process(delta):
	size -= delta * decreaseSpeed
	self.apply_scale( Vector2(size,size) )

func increase_size(ammount):
	size += ammount
