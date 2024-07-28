extends Node2D

@export var TimeBetweenSpawns = 4
@export var DistanceFromPlayer = 300
@export var TimeBetweenWaves = 49
@export var WaveSize = 20
@export var TimeBetweenCircles = 91
@export var CircleEnemyCount = 100.0
@export var CircleDistance = 500
@export var BigEnemyTime = 73
@export var EnemyScene: PackedScene

var EnemySpawnTimer
var WaveSpawnTimer
var CircleSpawnTimer
var BigEnemyTimer
var Player

func _ready():
	Player = get_parent().get_node("Player")
	set_timers()


func _process(_delta):
	pass

func set_timers():
	EnemySpawnTimer = $NormalEnemyTimer
	EnemySpawnTimer.timeout.connect(_on_spawn_timeout)
	EnemySpawnTimer.start(TimeBetweenSpawns)
	
	WaveSpawnTimer = $WaveSpawnTimer
	WaveSpawnTimer.timeout.connect(spawn_wave)
	WaveSpawnTimer.start(TimeBetweenWaves)
	
	CircleSpawnTimer = $CircleWaveTimer
	CircleSpawnTimer.timeout.connect(spawn_circle)
	CircleSpawnTimer.start(TimeBetweenCircles)
	
	BigEnemyTimer = $BigEnemyTimer
	BigEnemyTimer.timeout.connect(spawn_big_enemy)
	BigEnemyTimer.start(BigEnemyTime)
	

func _on_spawn_timeout():
	var enemy = EnemyScene.instantiate()
	var direction = Vector2(randf_range(-10, 10), randf_range(10, -10)).normalized()
	var enemy_location = Player.position + DistanceFromPlayer * direction
	enemy.position = enemy_location
	enemy.add_to_group("enemies")
	get_parent().get_node("EnemyManager").add_child(enemy) 

func spawn_wave():
	var direction = Vector2(randf_range(-10, 10), randf_range(10, -10)).normalized()
	var enemy_location = Player.position + 2*DistanceFromPlayer * direction
	for i in WaveSize:
		var push = Vector2(randf_range(-0.5, .5), randf_range(-0.5, .5))
		var enemy = EnemyScene.instantiate()
		enemy.position = enemy_location + push
		enemy.Health = enemy.Health/2
		enemy.Speed = 2*enemy.Speed
		enemy.add_to_group("enemies")
		get_parent().get_node("EnemyManager").add_child(enemy) 

func spawn_circle():
	var direction = Vector2(1,0).normalized()
	var enemy_location = Player.position + CircleDistance * direction
	var turn_per_enemy = deg_to_rad(360/CircleEnemyCount)
	for i in CircleEnemyCount:
		var enemy = EnemyScene.instantiate()
		enemy.position = enemy_location
		enemy.Speed = 0.2*enemy.Speed
		enemy.add_to_group("enemies")
		get_parent().get_node("EnemyManager").add_child(enemy)
		enemy_location = enemy_location.rotated(turn_per_enemy)

func spawn_big_enemy():
	var enemy = EnemyScene.instantiate()
	var direction = Vector2(randf_range(-10, 10), randf_range(10, -10)).normalized()
	var enemy_location = Player.position + 1.5*DistanceFromPlayer * direction
	enemy.position = enemy_location
	enemy.Health = 10*enemy.Health
	enemy.Speed = 0.4*enemy.Speed
	enemy.add_to_group("enemies")
	get_parent().get_node("EnemyManager").add_child(enemy) 

