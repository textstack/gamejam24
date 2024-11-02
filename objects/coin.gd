extends Area2D


var amount = 1

var zone = 0
var point


func _on_body_entered(body: Node) -> void:
	if body is Player:
		Currencies.money.add(5 ** zone)
		queue_free()
		if point:
			point.visible = true
