extends Control

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_go_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
