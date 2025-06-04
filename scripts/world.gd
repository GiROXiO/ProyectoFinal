class_name World
extends Node2D

@onready var player = $Player
@onready var inventory = $GUI/InventoryGUI
@onready var healthBar = $GUI/HeatlhBar
@onready var misionCompleted = $GUI/MissionsCompleted
@onready var submenu =  $GUI/SubMenuContainer
var misionCompletedPercentage :float
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
	global.pause = submenu.visible
	misionCompletedPercentage = snapped(get_misions_completed(), 0.01)
	misionCompleted.text = "Misiones: " + "\n" + str(misionCompletedPercentage, "%") 
	self._filter_changed(OptionsBus.current_filter)
	playMusic()

func _on_inventory_opened():
	pass
	#get_tree().paused = true

func _on_inventory_closed():
	pass
	#get_tree().paused = false

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

func get_misions() -> Array[bool]:
	var misions: Array[bool]
	misions.append(Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_completed)
	misions.append(Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_completed)
	misions.append( Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_completed)
	misions.append(Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_mission_completed)
	misions.append(Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_mission_completed)
	misions.append(Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_mission_completed)
	misions.append(Dialogic.VAR.MissionAcepted.Angel_Mission.angel_mission_completed)
	return misions
	
func get_misions_completed() -> float:
	var misions: Array[bool] = get_misions()
	var completed: float = 0
	for mision in misions:
		if(mision):
			completed += 1
	return completed/ 7 * 100
