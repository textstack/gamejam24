extends Node


var speed = {}
var heal = {}
var health = {}


func _ready() -> void:
	newUpgrade("small_sketch", "health", 4, 1.3, 3)
	newUpgrade("hopefulness", "health", 40, 1.3, 12)
	newUpgrade("new_hobby", "health", 200, 1.3, 60)
	
	newUpgrade("clean_water", "heal", 8, 1.4, 1)
	newUpgrade("bandages", "heal", 60, 1.4, 5)
	newUpgrade("first_aid", "heal", 300, 1.4, 25)
	
	newUpgrade("good_food", "speed", 25, 2, 25)
	newUpgrade("energy_drink", "speed", 400, 2, 50)


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
