extends Area2D


var amount = 1


func _on_body_entered(body: Node) -> void:
	if body is Player:
		Currencies.money.add(1)
		queue_free()
