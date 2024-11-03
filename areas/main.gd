extends Node2D

var coin = preload("res://objects/coin.tscn")
var enemy = preload("res://objects/enemy.tscn")
@onready var hud = $CanvasLayer/hud

func isOnScreen(pos):
	var posAdjust = pos + $PlaySpace.position + get_viewport_rect().size / 2
	
	if posAdjust.x < 0 or posAdjust.y < 0:
		return false
		
	if posAdjust.x > get_viewport_rect().size.x or posAdjust.y > get_viewport_rect().size.y:
		return false
	
	return true


func spawnObject(type, frac):
	var inst = type.instantiate()
	var zone = randi_range(0, 2)
	var point = getRandomPlace(zone, frac + zone * 0.1)
	
	if not point:
		return
		
	if isOnScreen(point.position):
		return
	
	point.visible = false
	
	inst.position = point.position
	inst.setup(zone, point)
	
	$PlaySpace.add_child(inst)


func getRandomPlace(zone, frac):
	var spawns
	if zone == 0:
		spawns = $PlaySpace/Zone0/Spawns
	elif zone == 1:
		spawns = $PlaySpace/Zone1/Spawns
	elif zone == 2:
		spawns = $PlaySpace/Zone2/Spawns
	
	var children = spawns.get_children()
	var selectable = []
	for i in children.size():
		if children[i].visible:
			selectable.append(children[i])
	
	if selectable.size() <= 0:
		return null
	
	if selectable.size() / float(children.size()) < (1 - frac):
		return null
	
	return selectable[randi() % selectable.size()]


const letters = { "0": "C", "1": "B", "2": "A" }

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#$CanvasLayer/RichTextLabel.text = "money: " + str(Currencies.money.total) + " health: " + str(Currencies.health.total) + " zone: " + str(Currencies.zone)
	hud._set_money(Currencies.money.total)
	hud._set_health(Currencies.health.total, Currencies.health.getMax())
	
	if (Currencies.zone == -1):
		hud._set_zone("S (+" + str(Upgrades.getHeal()) + "/s)")
	else:
		hud._set_zone(letters[str(Currencies.zone)])
	
	hud._set_curr_weapon(Currencies.weapon_tier)
	$PlaySpace.position = -$PlaySpace/Player.position
	
	spawnObject(enemy, 0.25)
	spawnObject(coin, 0.3)
	
