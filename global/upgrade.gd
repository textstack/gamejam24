extends Node

class_name Upgrade


var upgradeName = "Basic Health"
var type = "health"
var basePrice = 10
var priceIncrease = 1.3
var increase = 1

var amount = 0
var currentPrice = basePrice


func _init(upgradeName_, type_, basePrice_, priceIncrease_, increase_):
	upgradeName = upgradeName_
	type = type_
	basePrice = basePrice_
	priceIncrease = priceIncrease_
	increase = increase_


func getName():
	return upgradeName


func getAmount():
	return amount


func getIncrease():
	return amount * increase


func getPrice():
	return ceil(basePrice * (priceIncrease ** amount))


func add():
	amount += 1


func trySpend():
	if Currencies.money.trySpend(getPrice()):
		add()
		return true
	
	return false
