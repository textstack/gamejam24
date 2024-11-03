extends Node2D



@onready var purchase_sound = $AudioStreamPlayer2D
@onready var interaction_area: shopping = $Shopping
@onready var sprite = $Polygon2D
var cost


func _ready() -> void:
	interaction_area.Buy = Callable(self, "_on_interact")
	cost = 10
	$Shopping.shop_cost = cost
	$Shopping.action_name = "+weapon"


# where the actual changes to state of stuff happens
func _on_interact():
	if Currencies.money.trySpend(cost):
		cost *= 3
		$Shopping.shop_cost = cost
		print("Weapon Gained")
		purchase_sound.play()
		if Currencies.weapon_tier < 4:
			Currencies.weapon_tier += 1
		print(Currencies.weapon_tier)
		
		if Currencies.weapon_tier > 4:
			$Shopping.queue_free()
	else:
		print("Too poor for Weapon")
