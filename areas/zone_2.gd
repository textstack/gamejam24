extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Currencies.zone = 2


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		Currencies.zone = 1
