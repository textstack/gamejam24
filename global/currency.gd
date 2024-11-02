extends Node

class_name Currency


var icon = ""
var currencyName = "Money"
var total = 0


func _init(startTotal, currencyName_, icon_):
	total = startTotal
	currencyName = currencyName_
	icon = icon_


func getName():
	return currencyName


func getIcon():
	return icon


func add(amount):
	total += amount
	return true


func trySpend(amount):
	if total < amount:
		return false
	
	total -= amount
	return true
