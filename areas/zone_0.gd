extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player and Currencies.zone > 0:
		body.zoneCheck = 0
		Currencies.zone = 0


func _on_body_exited(body: Node2D) -> void:
	if body is Player and Currencies.zone >= 0 and body.zoneCheck == 0:
		body.zoneCheck = 1
		Currencies.zone = 1
