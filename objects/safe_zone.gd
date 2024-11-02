extends Area2D


var heal = 1


var player


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("TrackingEnemy"):
		body.die()
	
	if body is Player:
		Currencies.zone = -1
		player = body


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		Currencies.zone = 0
		player = null


func _on_heal_timer_timeout() -> void:
	if player:
		Currencies.health.add(heal)
