extends Node

var max_health
var health
var money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money = Currency.new(0, "Money", "")
	health = CurrencyMax.new(30, 30, "Health", "")
