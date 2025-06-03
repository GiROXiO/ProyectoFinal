class_name SaveMenu
extends Control

func _ready() -> void:
	$MonochromatismFilter.visible = false
	$ProtanopiaFilter.visible = false
	$TritanopiaFilter.visible = false
	
	self._filter_changed(OptionsBus.current_filter)

func _process(_delta: float) -> void:
	self._filter_changed(OptionsBus.current_filter)

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
