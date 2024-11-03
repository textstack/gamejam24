extends Area2D

var amount = 1

var zone = 0
var point

@onready var coin_sound = $Pick_up

func setup(zone_, point_):
	zone = zone_
	point = point_


func _on_body_entered(body: Node) -> void:
	if body is Player:
		Currencies.money.add(5 ** zone)
		queue_free()
		if point:
			point.visible = true
		
