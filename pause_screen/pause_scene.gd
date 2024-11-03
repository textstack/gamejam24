extends Control

var showing = false

func _ready():
	# Start hidden
	hide()
	# Make sure this node can process even when game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):  # Using escape key
		if showing:
			resume()
		else:
			pause()

func pause():
	print("Pausing...") # Debug print
	show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	showing = true

func resume():
	print("Resuming...") # Debug print
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	showing = false

func _on_continue_pressed() -> void:
	resume()

func _on_reset_pressed() -> void:
	resume()
	Currencies.resetCurrencies()
	# out reset function call here
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	Currencies.resetCurrencies()
	get_tree().change_scene_to_file("res://title_screen/title_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
