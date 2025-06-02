class_name Option
extends Control

@onready var prot = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter1
@onready var trit = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter2
@onready var mon = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter3
@onready var optionBus = OptionsBus
@export var ingame: bool
@onready var brightness_slider = $MarginContainer/GridContainer/BrilloContainer/BrilloSlider


func _ready() -> void:
	$MarginContainer/GridContainer/FullScreenButtonResolutions2.select(0)


#func _on_back_pressed() -> void:
	#self.visible = false

func _on_btn_filter_1_pressed() -> void:
	OptionsBus.current_filter = "protanopia"
	get_tree().paused = false

func _on_btn_filter_2_pressed() -> void:
	OptionsBus.current_filter = "tritanopia"
	get_tree().paused = false

func _on_btn_filter_3_pressed() -> void:
	OptionsBus.current_filter = "monocromatismo"
	get_tree().paused = false

func _on_btn_filter_4_pressed() -> void:
	OptionsBus.current_filter = ""
	get_tree().paused = false

func _on_back_button_up() -> void:
	if ingame == true:
		get_tree().paused = true


func _on_back_button_down() -> void:
	self.visible = false

func _toggle_fullscreen(state):
	if state == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		print("Funciona")
	else:
		print("No funciona")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_full_screen_button_resolutions_2_item_selected(index: int) -> void:
	_toggle_fullscreen(index)
