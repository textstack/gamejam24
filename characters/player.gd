extends CharacterBody2D

class_name Player


const SPEED = 250.0
const SMOOTH = 0.6


func takeDamage(amount):
	if not amount:
		amount = 1
	
	Currencies.health.total -= amount
	if Currencies.health.total <= 0:
		die()


func die():
	get_tree().quit()


func _physics_process(_delta: float) -> void:
	var move = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"),
	)
	
	var speed = SPEED + Upgrades.getSpeed() * 50 - Currencies.zone * 50
	velocity = velocity.lerp(move.normalized() * speed, SMOOTH)
	
	move_and_slide()


func _process(_delta: float) -> void:
	if Currencies.zone < 0:
		$HPTimer.wait_time = 2
		return
	
	$HPTimer.wait_time = 2.0 / (3 ** Currencies.zone)


func _on_hp_timer_timeout() -> void:
	if Currencies.zone < 0:
		return
	
	takeDamage(1)
	
