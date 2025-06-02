extends Control

@onready var options = $CanvasLayer/options
@onready var help = $CanvasLayer/help_menu

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/save_menu.tscn")


func _on_options_pressed() -> void:
	options.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_help_pressed() -> void:
	help.visible = true
	


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/creditos.tscn")
