extends Currency

class_name CurrencyMax


var highestAllowed = 0


func _init(startTotal, startMax, currencyName_, icon_):
	total = startTotal
	highestAllowed = startMax
	currencyName = currencyName_
	icon = icon_


func add(amount):
	if total + amount > highestAllowed:
		total = highestAllowed
		return false
	
	total += amount
	return true


func getMax():
	return highestAllowed
	

func addMax(amount):
	highestAllowed += amount
