class_name Option
extends Control

@onready var prot = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter1
@onready var trit = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter2
@onready var mon = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter3
@onready var optionBus = OptionsBus

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

func _on_btn_filter_1_pressed() -> void:
	print("Boton de Protonopia presionado")
	OptionsBus.current_filter = "protanopia"
	print(OptionsBus.current_filter)

func _on_btn_filter_2_pressed() -> void:
	print("Boton de Tritanopia presionado")
	OptionsBus.current_filter = "tritanopia"
	print(OptionsBus.current_filter)

func _on_btn_filter_3_pressed() -> void:
	print("Boton de Monocromatismo presionado")
	OptionsBus.current_filter = "monocromatismo"
	print(OptionsBus.current_filter)
