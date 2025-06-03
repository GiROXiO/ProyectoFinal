extends Control

@onready var options = $CanvasLayer/options
@onready var help = $CanvasLayer/help_menu

func _ready() -> void:
	$MonochromatismFilter.visible = false
	$ProtanopiaFilter.visible = false
	$TritanopiaFilter.visible = false
	
	self._filter_changed(OptionsBus.current_filter)

func _process(_delta: float) -> void:
	self._filter_changed(OptionsBus.current_filter)

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

func _filter_changed(filter: String):
	match filter:
		"protanopia":
			$ProtanopiaFilter.visible = true
			$TritanopiaFilter.visible = false
			$MonochromatismFilter.visible = false
		"tritanopia":
			$ProtanopiaFilter.visible = false
			$TritanopiaFilter.visible = true
			$MonochromatismFilter.visible = false
		"monocromatismo":
			$ProtanopiaFilter.visible = false
			$TritanopiaFilter.visible = false
			$MonochromatismFilter.visible = true
		"":
			$ProtanopiaFilter.visible = false
			$TritanopiaFilter.visible = false
			$MonochromatismFilter.visible = false
