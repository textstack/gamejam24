extends Node2D


@onready var interaction_area: shopping = $Shopping
@onready var sprite = $Polygon2D
var cost


func _ready() -> void:
	interaction_area.Buy = Callable(self, "_on_interact")
	
	cost = name.to_int()
	$Shopping.shop_cost = cost
	$Shopping.action_name = "+route"


# where the actual changes to state of stuff happens
func _on_interact():
	if Currencies.money.trySpend(cost):
		get_parent().queue_free()
