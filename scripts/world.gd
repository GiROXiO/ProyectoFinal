class_name World
extends Node2D

@onready var player = $Player
@onready var inventory = $GUI/InventoryGUI
@onready var healthBar = $GUI/HeatlhBar
@onready var filter_name: String

func _ready():
	inventory.opened.connect(_on_inventory_opened)
	inventory.closed.connect(_on_inventory_closed)
	global.player_current_attack = false
	
	$TritanopiaFilter/TritanopiaOL.visible = false
	$ProtanopiaFilter/ProtanopiaOL.visible = false
	$MonochromatismFilter/MonochromatismOL.visible = false
	
	print(OptionsBus.current_filter)
	#filter_name = OptionsBus.current_filter
	#self._filter_changed(filter_name)

func _process(delta: float) -> void:
	healthBar.value = player.get_life()
	filter_name = OptionsBus.current_filter
	self._filter_changed(filter_name)

func _on_inventory_opened():
	get_tree().paused = true

func _on_inventory_closed():
	get_tree().paused = false

func _filter_changed(filter_name: String):
	print("Recibida señal para filtro de ", filter_name)
	match filter_name:
		"protanopia":
			print("Detectada protanopia")
			$ProtanopiaFilter/ProtanopiaOL.visible = true
			$TritanopiaFilter/TritanopiaOL.visible = false
			$MonochromatismFilter/MonochromatismOL.visible = false
		"tritanopia":
			print("Detectada tritanopia")
			$ProtanopiaFilter/ProtanopiaOL.visible = false
			$TritanopiaFilter/TritanopiaOL.visible = true
			$MonochromatismFilter/MonochromatismOL.visible = false
		"monocromatismo":
			print("Detectado monocromatismo")
			$ProtanopiaFilter/ProtanopiaOL.visible = false
			$TritanopiaFilter/TritanopiaOL.visible = false
			$MonochromatismFilter/MonochromatismOL.visible = true
		"":
			print("Apagado de filtros")
			$ProtanopiaFilter/ProtanopiaOL.visible = false
			$TritanopiaFilter/TritanopiaOL.visible = false
			$MonochromatismFilter/MonochromatismOL.visible = false
