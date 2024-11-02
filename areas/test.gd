extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$RichTextLabel.text = "money: " + str(Currencies.money.total) + "health: " + str(Currencies.health.total)
