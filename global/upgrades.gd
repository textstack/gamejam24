extends Node


var speed = {}
var heal = {}
var health = {}


func _ready() -> void:
	newUpgrade("small_sketch", "health", 1, 1, 20)
	newUpgrade("hopefulness", "health", 3, 2, 50)
	newUpgrade("new_hobby", "health", 5, 4, 100)
	
	newUpgrade("clean_water", "heal", 1, 1, 20)
	newUpgrade("bandages", "heal", 3, 1, 50)
	newUpgrade("first_aid", "heal", 5, 2, 100)
	
	newUpgrade("good_food", "speed", 1, 2, 25)
	newUpgrade("energy_drink", "speed", 2, 2, 50)


func reset():
	for i in speed:
		speed[i].reset()
	
	for i in heal:
		heal[i].reset()
	
	for i in health:
		health[i].reset()


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
