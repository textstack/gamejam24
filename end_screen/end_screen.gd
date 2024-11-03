extends Control
signal reset
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_restart_pressed() -> void:
	hide()
	get_tree().paused = false
	Currencies.resetCurrencies()
	Upgrades.reset()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen/title_scene.tscn")
