extends Node2D


@onready var interaction_area: shopping = $Shopping
@onready var sprite = $Polygon2D

func _ready() -> void:
	interaction_area.Buy = Callable(self, "_on_interact")

# where the actual changes to state of stuff happens
func _on_interact():
	print("Wow You Bought Some health")
