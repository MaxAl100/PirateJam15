extends CharacterBody2D

@export var damage = 10
@export var Speed = 15.0
var SlowDownEffect = 1
var DamageMultiplier = 1
@export var Health = 3.0

@export var InvincibilityTime = 0.5
@export var KnockbackResistance = 0.4
var Invincibilities: Array[PackedScene] = []
var currInvincibility: Array[float] = []

var Player
var Direction

func _ready():
	Player = get_parent().get_parent().get_node("Player")
	self.add_to_group("enemies")


func _physics_process(delta):
	for pos in currInvincibility.size():
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
	if entity in Invincibilities:
		return
	var rec_damage = entity.damage
	InvincibilityTime.append(entity)
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

