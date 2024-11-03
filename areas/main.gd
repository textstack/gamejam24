extends Node2D

var coin = preload("res://objects/coin.tscn")
var enemy = preload("res://objects/enemy.tscn")
var title_screen = preload("res://title_screen/title_scene.gd")
@onready var hud = $CanvasLayer/hud
@onready var player = $PlaySpace/Player
@onready var end_screen = $CanvasLayer/EndScreen

func _ready() -> void:
	end_screen.hide()
	player.died.connect(on_death)
	
func on_death():
	get_tree().paused = true
	end_screen.show()

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
	var point = getRandomPlace(inst, zone, frac)
	
	if not point:
		inst.queue_free()
		return
		
	if isOnScreen(point.position):
		inst.queue_free()
		return
	
	point.visible = false
	
	inst.position = point.position
	inst.setup(zone, point)
	
	$PlaySpace.add_child(inst)


func getRandomPlace(inst, zone, frac):
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
		if inst.canSpawn(children[i]):
			selectable.append(children[i])
	
	if selectable.size() <= 0:
		return null
	
	if selectable.size() / float(children.size()) < (1 - frac):
		return null
	
	return selectable[randi() % selectable.size()]


const letters = { "0": "C", "1": "B", "2": "A" }

var won

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if won:
		return
	
	#$CanvasLayer/RichTextLabel.text = "money: " + str(Currencies.money.total) + " health: " + str(Currencies.health.total) + " zone: " + str(Currencies.zone)
	hud._set_money(Currencies.money.total)
	hud._set_health(Currencies.health.total, Currencies.health.getMax())
	
	if (Currencies.zone == -1):
		hud._set_zone("S (+" + str(Upgrades.getHeal()) + "/s)")
	else:
		hud._set_zone(letters[str(Currencies.zone)])
	
	hud._set_curr_weapon(Currencies.weapon_tier)
	$PlaySpace.position = -$PlaySpace/Player.position
	
	spawnObject(enemy, 0.15)
	spawnObject(coin, 0.3)
	


func _on_player_pistol_b(bullet: Variant, velo: Variant, posit: Variant) -> void:
	$PlaySpace.add_child(bullet)
	bullet.global_position = posit
	bullet.velocity = velo


func _on_win_check_body_entered(body: Node2D) -> void:
	if body is Player:
		won = true
		$CanvasLayer/YouWin.visible = true
		$PlaySpace.queue_free()
