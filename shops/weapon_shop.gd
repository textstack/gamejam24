extends Node2D



@onready var interaction_area: shopping = $Shopping
@onready var sprite = $Polygon2D
var cost


func _ready() -> void:
	interaction_area.Buy = Callable(self, "_on_interact")
	cost = 1
	$Shopping.shop_cost = cost
	$Shopping.action_name = "+weapon"


# where the actual changes to state of stuff happens
func _on_interact():
	if Currencies.money.trySpend(cost):
		cost *= 2
		$Shopping.shop_cost = cost
		print("Weapon Gained")
		Currencies.weapon_tier += 1
		print(Currencies.weapon_tier)
		
		if Currencies.weapon_tier > 4:
			$Shopping.queue_free()
	else:
		print("Too poor for Weapon")
