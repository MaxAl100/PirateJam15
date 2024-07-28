extends CharacterBody2D

@export var damage = 10
@export var Speed = 15.0
var SlowDownEffect = 1
var DamageMultiplier = 1
@export var Health = 30.0

@export var InvincibilityTime = 0.5
@export var TotalInvincibilityTime = 0.1
@export var KnockbackResistance = 0.4
var Invincibilities: Array[Area2D] = []
var currInvincibility: Array[float] = []
var TotalInvincibility = 0

var Player
var Direction

func _ready():
	Player = get_parent().get_parent().get_node("Player")
	self.add_to_group("enemies")


func _physics_process(delta):
	if TotalInvincibility > 0:
		TotalInvincibility -= delta
	for pos in range(currInvincibility.size() - 1, -1, -1):
		currInvincibility[pos] -= delta
		if currInvincibility[pos] <= 0:
			currInvincibility.remove_at(pos)
			Invincibilities.remove_at(pos)

	if SlowDownEffect > 1:
		SlowDownEffect = 1
	elif SlowDownEffect < 1:
		SlowDownEffect += 0.5 * delta

	if Health > 0:
		Direction = (Player.position - self.position).normalized()
		velocity = Direction * Speed * SlowDownEffect
		move_and_slide()

func _recieve_damage(entity):
	if entity in Invincibilities or TotalInvincibility > 0:
		return
	TotalInvincibility = TotalInvincibilityTime
	var rec_damage = entity.damage
	Invincibilities.append(entity)
	currInvincibility.append(InvincibilityTime)
	Health -= rec_damage * DamageMultiplier
	if Health <= 0:
		self.queue_free()
	else:
		apply_knockback(entity)
		
func get_damage():
	return damage


func apply_knockback(entity):
	var knockback_direction = (position - entity.position).normalized()
	position -= knockback_direction * entity.knockback * KnockbackResistance

func apply_pull_force(source_position, strength, delta):
	var pull_direction = (source_position - position).normalized()
	position += pull_direction * strength * delta

