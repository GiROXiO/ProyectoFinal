class_name Option
extends Control

@onready var prot = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter1
@onready var trit = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter2
@onready var mon = $MarginContainer/GridContainer/BtnFilterContainer/btnFilter3
@onready var optionBus = OptionsBus
@onready var brightness_slider = $MarginContainer/GridContainer/BrilloContainer/BrilloSlider
@onready var fullscream = $MarginContainer/GridContainer/FullScreenButtonResolutions2

func _ready() -> void:
	$MarginContainer/GridContainer/FullScreenButtonResolutions2.select(0)
	$TritanopiaFilter.visible = false
	$ProtanopiaFilter.visible = false
	$MonochromatismFilter.visible = false

func _process(delta: float) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		fullscream.selected = 0
	else:
		fullscream.selected = 1
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
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		print("Funciona")
	else:
		print("No funciona")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_full_screen_button_resolutions_2_item_selected(index: int) -> void:
	_toggle_fullscreen(index)


func _on_brillo_slider_value_changed(value: float) -> void:
	#En cuanto a lo que tienes que guardar es el valor  de Brightness.environment.adjustment_brightness
	#Cuando incias el juego se asigna y eso tambien se refleja el valor del HSlider que representa el brillo
	Brightness.environment.adjustment_brightness = value
