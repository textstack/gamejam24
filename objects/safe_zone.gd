extends Area2D


const HEAL = 1


var player


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("TrackingEnemy"):
		body.die()
	
	if body is Player:
		player = body
		player.safe = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player.safe = false
		player = null


func _on_heal_timer_timeout() -> void:
	if player:
		Currencies.health.add(HEAL)
