extends Node2D

@onready var purchase_sound = $AudioStreamPlayer2D
@onready var interaction_area: shopping = $Shopping
@onready var sprite = $Polygon2D
var upgradeName
var type

func _ready() -> void:
	interaction_area.Buy = Callable(self, "_on_interact")
	
	var split = name.split("_", true, 1)
	if split.size() < 2:
		return
	
	type = split[0]
	upgradeName = split[1]
	
	var upgrade = Upgrades.getType(type)[upgradeName]
	if not upgrade:
		return
	
	$Shopping.shop_cost = upgrade.getPrice()
	$Shopping.action_name = "+" + upgradeName.replace("_", " ")


# where the actual changes to state of stuff happens
func _on_interact():
	var upgrade = Upgrades.getType(type)[upgradeName]
	if not upgrade:
		return
	#check if purchase made
	if upgrade.trySpend():
		purchase_sound.play()
	$Shopping.shop_cost = upgrade.getPrice()
	
