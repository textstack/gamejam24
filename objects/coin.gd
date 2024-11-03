extends Area2D

var amount = 1

var zone = 0
var point

@onready var purchase_sound  = $AudioStreamPlayer2D

func canSpawn(point_):
	return point_.visible


func setup(zone_, point_):
	zone = zone_
	point = point_
	
	point_.visible = false
	
	if zone > 0:
		$Sprite2D2.visible = true
	
	if zone > 1:
		$Sprite2D3.visible = true


func _on_body_entered(body: Node) -> void:
	if body is Player:
		
		Currencies.money.add(5 ** zone)
		queue_free()
		if point:
			point.visible = true
		
