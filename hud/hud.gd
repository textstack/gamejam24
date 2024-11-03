extends Control

# Onready vars
@onready var curr_weapon = $hud_inventory/current_weapon
@onready var curr_health = $hud_inventory/health
@onready var curr_money = $hud_inventory/money
@onready var curr_zone = $hud_inventory/zone

# Initialize
var health: int = 100
var money: int = 0
var zone: String = "S"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize
	curr_weapon.texture = load("res://art/hud/empty.png")
	curr_health.bbcode_text = '[color=797165]HEALTH: ' + str(health) + '[/color]'
	curr_money.bbcode_text = '[color=797165]$ ' + str(money) + '[/color]'
	curr_zone.bbcode_text = '[color=797165]ZONE: ' + zone + '[/color]'

# Updates the zone
func _set_zone(new_zone: String):
	zone = new_zone
	curr_zone.bbcode_text = '[color=797165]ZONE: ' + zone + '[/color]'

# Updates the moneyhud._set_health(Currencies.health.total)
func _set_money(amount: int):
	money = amount
	curr_money.bbcode_text = '[color=797165]$' + str(money) + '[/color]'

# Updates the health
func _set_health(amount: int, limit: int):
	health = amount
	curr_health.bbcode_text = '[color=797165]HP: ' + str(health) + '/' + str(limit) + '[/color]'

# Function to update current weapon
func _set_curr_weapon(weapon: int):
	match weapon:
		0:
			curr_weapon.texture = load("res://art/hud/empty.png")
		1:
			curr_weapon.texture = load("res://art/hud/knife.png")
		2:
			curr_weapon.texture = load("res://art/hud/pipe_sign.png")
		3:
			curr_weapon.texture = load("res://art/hud/gun.png")
		4:
			curr_weapon.texture = load("res://art/hud/shotgun.png")
