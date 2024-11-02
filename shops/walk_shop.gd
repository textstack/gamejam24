extends Node2D

@onready var interaction_area: shopping = $Shopping
@onready var sprite = $Polygon2D
var cost

func _ready() -> void:
	interaction_area.Buy = Callable(self, "_on_interact")
	cost = 1
	$Shopping.shop_cost = cost
	
	
# where the actual changes to state of stuff happens
func _on_interact():
	if Currencies.money.trySpend(cost):
		print("Speed Gained")
	else:
		print("Too poor for Speed")
