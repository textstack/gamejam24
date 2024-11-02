extends CharacterBody2D

class_name Player


const SPEED = 300.0
const SMOOTH = 0.6


var safe = false


func takeDamage(amount):
	if not amount:
		amount = 1
	
	Currencies.health.total -= amount
	if Currencies.health.total <= 0:
		die()


func die():
	pass


func _physics_process(_delta: float) -> void:
	var move = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"),
	)
	
	velocity = velocity.lerp(move.normalized() * SPEED, SMOOTH)
	
	move_and_slide()
