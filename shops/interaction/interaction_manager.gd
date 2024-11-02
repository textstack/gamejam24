extends Node2D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

# Label Base text
const base_text = "[E]"

# Array fo interactables your around
var active_areas = []
var can_interact = true

# Adds near interactables to array
func register_area(area: shopping):
	active_areas.push_back(area)

# Pulls area out of the array when characters no longer in it
func unregister_area(area: shopping):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
		
# Redraws label using whichever interactable your closest too
func _process(_delta: float) -> void:
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = str(active_areas[0].shop_cost) + '$ ' + base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 45
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()
		
# The distance sorter
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
# The input button
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].Buy.call()
			
			can_interact = true
