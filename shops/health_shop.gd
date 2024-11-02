extends Node2D


@onready var interaction_area: shopping = $Shopping
@onready var sprite = $Polygon2D

func _ready() -> void:
	interaction_area.Buy = Callable(self, "_on_interact")
	
func _on_interact():
	print("Wow You Bought Something")
