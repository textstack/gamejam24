extends Currency

class_name CurrencyMax


var max = 0


func _init(startTotal, startMax, currencyName, icon):
	total = startTotal
	max = startMax
	currencyName = currencyName
	icon = icon


func add(amount):
	if total + amount > max:
		total = max
		return false
	
	total += amount
	return true


func getMax():
	return max
	

func addMax(amount):
	max += amount
