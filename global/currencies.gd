extends Node

var max_health
var health
var money
var weapon_tier
var zone = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money = Currency.new(0, "Money", "")
	weapon_tier = 0
	health = Health.new(6, 6, "Health", "")
	
func resetCurrencies() -> void:
	health.total = 6
	money.total = 50000
	weapon_tier = 0
