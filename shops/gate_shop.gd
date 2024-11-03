extends Node2D


@onready var purchase_sound = $AudioStreamPlayer2D
@onready var interaction_area: shopping = $Shopping
@onready var sprite = $Polygon2D
var cost


func _ready() -> void:
	interaction_area.Buy = Callable(self, "_on_interact")
	
	cost = name.to_int()
	$Shopping.shop_cost = cost
	$Shopping.action_name = "+route"


# where the actual changes to state of stuff happens
func _on_interact():
	if Currencies.money.trySpend(cost):
		purchase_sound.play()
		#needs time to play the sound before being free'd
		await get_tree().create_timer(2).timeout
		get_parent().queue_free()
