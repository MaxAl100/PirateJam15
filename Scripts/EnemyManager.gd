extends Node2D

@export var TimeBetweenSpawns = 4
@export var DistanceFromPlayer = 300
@export var EnemyScene: PackedScene

var EnemySpawnTimer
var Player

func _ready():
	EnemySpawnTimer = $Timer
	EnemySpawnTimer.wait_time = TimeBetweenSpawns
	EnemySpawnTimer.timeout.connect(_on_spawn_timeout)
	EnemySpawnTimer.start(TimeBetweenSpawns)
	Player = get_parent().get_node("Player")


func _process(delta):
	pass
	
	

func _on_spawn_timeout():
	var enemy = EnemyScene.instantiate()
	var direction = Vector2(randf_range(-10, 10), randf_range(10, -10)).normalized()
	var enemy_location = Player.position + DistanceFromPlayer * direction
	enemy.position = enemy_location
	get_parent().get_node("EnemyManager").add_child(enemy) 
