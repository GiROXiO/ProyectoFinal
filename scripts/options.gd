class_name Option
extends Control

@onready var prot = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter1
@onready var trit = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter2
@onready var mon = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter3
@onready var optionBus = OptionsBus
@onready var brightness_slider = $MarginContainer/GridContainer/BrilloContainer/BrilloSlider


func _ready() -> void:
	$MarginContainer/GridContainer/FullScreenButtonResolutions2.select(0)
	$TritanopiaFilter.visible = false
	$ProtanopiaFilter.visible = false
	$MonochromatismFilter.visible = false
	


func _on_back_pressed() -> void:
	self.visible = false

func _on_btn_filter_1_pressed() -> void:
	OptionsBus.current_filter = "protanopia"
	$TritanopiaFilter.visible = false
	$ProtanopiaFilter.visible = true
	$MonochromatismFilter.visible = false
	#get_tree().paused = false
	gameData.saveFilter()

func _on_btn_filter_2_pressed() -> void:
	OptionsBus.current_filter = "tritanopia"
	$TritanopiaFilter.visible = true
	$ProtanopiaFilter.visible = false
	$MonochromatismFilter.visible = false
	#get_tree().paused = false
	gameData.saveFilter()

func _on_btn_filter_3_pressed() -> void:
	OptionsBus.current_filter = "monocromatismo"
	$TritanopiaFilter.visible = false
	$ProtanopiaFilter.visible = false
	$MonochromatismFilter.visible = true
	#get_tree().paused = false
	gameData.saveFilter()

func _on_btn_filter_4_pressed() -> void:
	OptionsBus.current_filter = ""
	$TritanopiaFilter.visible = false
	$ProtanopiaFilter.visible = false
	$MonochromatismFilter.visible = false
	#get_tree().paused = false
	gameData.saveFilter()



func _on_back_button_down() -> void:
	self.visible = false

func _toggle_fullscreen(state):
	if state == 1:
		get_window().mode = Window.MODE_FULLSCREEN
		print("Funciona")
	else:
		print("No funciona")
		get_window().mode = Window.MODE_WINDOWED


func _on_full_screen_button_resolutions_2_item_selected(index: int) -> void:
	_toggle_fullscreen(index)
