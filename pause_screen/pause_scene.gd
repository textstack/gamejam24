extends Control

var showing = false

func _ready() -> void:
	hide()  # Start hidden

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if showing:
			resume()
		else:
			pause()

func pause():
	print("Pausing...")  # Debug print
	show()  # Show the pause menu
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	showing = true

func resume():
	print("Resuming...")  # Debug print
	hide()  # Hide the pause menu
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	showing = false

# Button functions
func _on_continue_pressed() -> void:
	resume()

func _on_reset_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen/title_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
