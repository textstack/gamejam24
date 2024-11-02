extends CurrencyMax

class_name Health


func getMax():
	return highestAllowed + Upgrades.getHealth()
