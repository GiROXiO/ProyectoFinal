class_name World
extends Node2D

@onready var player = $Player
@onready var inventory = $GUI/InventoryGUI
@onready var healthBar = $GUI/HeatlhBar

func _ready():
	inventory.opened.connect(_on_inventory_opened)
	inventory.closed.connect(_on_inventory_closed)
	global.player_current_attack = false
	
	$MonochromatismFilter.visible = false
	$ProtanopiaFilter.visible = false
	$TritanopiaFilter.visible = false
	self._filter_changed(OptionsBus.current_filter)
	randomize()

func _process(_delta) -> void:
	healthBar.value = player.get_life()
	self._filter_changed(OptionsBus.current_filter)
	playMusic()

func _on_inventory_opened():
	get_tree().paused = true

func _on_inventory_closed():
	get_tree().paused = false

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
