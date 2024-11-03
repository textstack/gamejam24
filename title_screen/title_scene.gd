extends Node2D

signal reset

func _on_start_pressed() -> void:
	Currencies.resetCurrencies()
	get_tree().change_scene_to_file("res://areas/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
