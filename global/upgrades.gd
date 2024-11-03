extends Node


var speed = {}
var heal = {}
var health = {}


func _ready() -> void:
	newUpgrade("small_sketch", "health", 5, 1.3, 3)
	newUpgrade("hopefulness", "health", 50, 1.3, 12)
	newUpgrade("new_hobby", "health", 250, 1.3, 60)
	
	newUpgrade("clean_water", "heal", 10, 1.8, 1)
	newUpgrade("bandages", "heal", 75, 1.6, 5)
	newUpgrade("first_aid", "heal", 350, 1.4, 25)
	
	newUpgrade("good_food", "speed", 50, 2, 5)
	newUpgrade("energy_drink", "speed", 150, 1.8, 10)


func getType(type):
	if type == "health":
		return health
	elif type == "speed":
		return speed
	elif type == "heal":
		return heal


func newUpgrade(upgradeName_, type_, basePrice_, priceIncrease_, increase_):
	var upgrade = Upgrade.new(upgradeName_, type_, basePrice_, priceIncrease_, increase_)
	if type_ == "health":
		health[upgradeName_] = upgrade
	elif type_ == "speed":
		speed[upgradeName_] = upgrade
	elif type_ == "heal":
		heal[upgradeName_] = upgrade


func getTotalIncrease(upgrades):
	var total = 0
	for upgrade in upgrades:
		total += upgrades[upgrade].getIncrease()
	
	return total


func getHeal():
	return getTotalIncrease(heal) + 1


func getSpeed():
	return getTotalIncrease(speed)


func getHealth():
	return getTotalIncrease(health)
