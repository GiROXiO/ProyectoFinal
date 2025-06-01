class_name Option
extends Control

@onready var prot = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter1
@onready var trit = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter2
@onready var mon = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter3
@onready var optionBus = OptionsBus
@export var ingame: bool

#func _on_back_pressed() -> void:
	#self.visible = false

func _on_btn_filter_1_pressed() -> void:
	print("Boton de Protonopia presionado")
	OptionsBus.current_filter = "protanopia"
	get_tree().paused = false
	print(OptionsBus.current_filter)

func _on_btn_filter_2_pressed() -> void:
	print("Boton de Tritanopia presionado")
	OptionsBus.current_filter = "tritanopia"
	get_tree().paused = false
	print(OptionsBus.current_filter)

func _on_btn_filter_3_pressed() -> void:
	print("Boton de Monocromatismo presionado")
	OptionsBus.current_filter = "monocromatismo"
	get_tree().paused = false
	print(OptionsBus.current_filter)


func _on_btn_filter_4_pressed() -> void:
	print("Boton de apagado de filtro presionado")
	OptionsBus.current_filter = ""
	get_tree().paused = false
	print(OptionsBus.current_filter)


func _on_back_button_up() -> void:
	if ingame == true:
		get_tree().paused = true


func _on_back_button_down() -> void:
	self.visible = false
