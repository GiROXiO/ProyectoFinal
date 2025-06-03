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
	self.filter_name = OptionsBus.current_filter
	self._filter_changed(filter_name)
	randomize()

func _process(_delta) -> void:
	healthBar.value = player.get_life()
	filter_name = OptionsBus.current_filter
	self._filter_changed(filter_name)
	playMusic()

func _on_inventory_opened():
	get_tree().paused = true

func _on_inventory_closed():
	get_tree().paused = false

func _filter_changed(filter: String):
	match filter:
		"protanopia":
			$ProtanopiaFilter/ProtanopiaOL.visible = true
			$TritanopiaFilter/TritanopiaOL.visible = false
			$MonochromatismFilter/MonochromatismOL.visible = false
		"tritanopia":
			$ProtanopiaFilter/ProtanopiaOL.visible = false
			$TritanopiaFilter/TritanopiaOL.visible = true
			$MonochromatismFilter/MonochromatismOL.visible = false
		"monocromatismo":
			$ProtanopiaFilter/ProtanopiaOL.visible = false
			$TritanopiaFilter/TritanopiaOL.visible = false
			$MonochromatismFilter/MonochromatismOL.visible = true
		"":
			$ProtanopiaFilter/ProtanopiaOL.visible = false
			$TritanopiaFilter/TritanopiaOL.visible = false
			$MonochromatismFilter/MonochromatismOL.visible = false

func playMusic() -> void:
	var songs = [
		get_node("/root/World/bg"),
		get_node("/root/World/bg2"),
		get_node("/root/World/bg3"),
		get_node("/root/World/bg4"),
		get_node("/root/World/bg5"),
		get_node("/root/World/bg6")
	]

	if not get_node("/root/World/bg").playing and not get_node("/root/World/bg2").playing and not get_node("/root/World/bg3").playing and not get_node("/root/World/bg4").playing and not get_node("/root/World/bg5").playing and not get_node("/root/World/bg6").playing:
		var index = randi() % songs.size()
		songs[index].play()
	
