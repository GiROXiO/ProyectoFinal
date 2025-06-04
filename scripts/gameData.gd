extends Node
class_name GameData

var data: Dictionary 

var slot: int = 0
 
var username: String = ""

var time: String

@export var player: Player

func _ready() -> void:
	load_from_file(1)
	load_from_file(2)
	load_from_file(3)
	loadFilter()

func restore() -> void:
	for i in to_dict_reset().keys():
		if not data.has(i):
			data[i] = to_dict_reset()[i]
	
	for i in saveDialogicReset().keys():
		if not data["quests"].has(i):
			data["quests"][i] = saveDialogicReset()[i]

func to_dict() -> Dictionary:	
	return {
		"username": username,
		'time':player.saveTime(),
		"health": player.saveHealth(),
		"inventory": player.inventory.to_dict(),
		"position": player.savePosition(),
		"quests": saveDialogic(),
		"filtro": OptionsBus.current_filter
	}

func to_dict_reset() -> Dictionary:
	return {
		"username": username,
		'time': 0,
		"health": 100,
		"weapon": 0,
		"inventory": {},
		"position": {"x": 3064,"y": 1486},
		"quests": saveDialogicReset(),
		"filtro": OptionsBus.current_filter
	}

func from_dict(dataLoad: Dictionary) -> void:
	data = dataLoad
	restore()
	username = data.get("username")
	loadDialogic()
	
func loadFilter() -> void:
	OptionsBus.current_filter = data.get("filtro")

func saveFilter() -> Dictionary:
	data["filtro"] = OptionsBus.current_filter
	return data

func setPlayer(pl: Player) -> void:
	player = pl
	
func saveDialogic() -> Dictionary:
	var quests = {
		"emissions_defeated": Dialogic.VAR.EnemiesDefeated.emissions_defeated,
		"garbage_defeated": Dialogic.VAR.EnemiesDefeated.garbage_defeated,
		"lumberjacks_defeated": Dialogic.VAR.EnemiesDefeated.lumberjacks_defeated,
		
		"emissions_defeated2": Dialogic.VAR.EnemiesDefeated2.emissions_defeated,
		"garbage_defeated2": Dialogic.VAR.EnemiesDefeated2.emissions_defeated,
		"lumberjacks_defeated2": Dialogic.VAR.EnemiesDefeated2.emissions_defeated,
		
		"luis_emissions": Dialogic.VAR.MissionAcepted.Luis_Mission.luis_emissions,
		"luis_mission_accepted": Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_accepted,
		"luis_mission_completed": Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_completed,
		
		"maritza_punches_dummy": Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_punches_dummy,
		"maritza_dummy": Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_dummy,
		"maritza_gas": Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_gas,
		"maritza_garbage_picker": Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_garbage_picker,
		"maritza_mission_accepted": Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_accepted,
		"maritza_mission_completed": Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_completed,
		
		
		"mono_emissions": Dialogic.VAR.MissionAcepted.Mono_Mission.mono_emissions,
		"mono_mission_acepted": Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_acepted,
		"mono_mission_completed": Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_completed,
		
		"ponllo_garbage": Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_garbage,
		"ponllo_mission_accepted": Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_mission_accepted,
		"ponllo_mission_completed": Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_mission_completed,
		
		"gabriella_pickup": Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_pickup, 
		"gabriella_mission_accepted": Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_mission_accepted,
		"gabriella_mission_completed": Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_mission_completed,
		
		"ignacio_lumberjacks": Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_lumberjacks,
		"ignacio_mission_accepted": Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_mission_accepted,
		"ignacio_mission_completed": Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_mission_completed, 
		
		"gabriella_pickup2": Dialogic.VAR.MissionAcepted.Gabriella_Mission2.gabriella_pickup, 
		"gabriella_mission_accepted2": Dialogic.VAR.MissionAcepted.Gabriella_Mission2.gabriella_mission_accepted,
		"gabriella_mission_completed2": Dialogic.VAR.MissionAcepted.Gabriella_Mission2.gabriella_mission_completed,
		
		"angel_pickup": Dialogic.VAR.MissionAcepted.Angel_Mission.angel_pickup, 
		"angel_mission_accepted": Dialogic.VAR.MissionAcepted.Angel_Mission.angel_mission_accepted,
		"angel_mission_completed": Dialogic.VAR.MissionAcepted.Angel_Mission.angel_mission_completed,
	}
	
	return quests
	
func saveDialogicReset() -> Dictionary:
	var quests = {
		"emissions_defeated": 0,
		"garbage_defeated": 0,
		"lumberjacks_defeated": 0,
		
		"emissions_defeated2": 0,
		"garbage_defeated2": 0,
		"lumberjacks_defeated2": 0,
		
		"luis_emissions": 0,
		"luis_mission_accepted": false,
		"luis_mission_completed": false,
		
		"maritza_punches_dummy": 0,
		"maritza_dummy": false,
		"maritza_gas": false,
		"maritza_garbage_picker": 0,
		"maritza_mission_accepted": false,
		"maritza_mission_completed": false,
		
		
		"mono_emissions": 0,
		"mono_mission_acepted": false,
		"mono_mission_completed": false,
		
		"ponllo_garbage": 0,
		"ponllo_mission_accepted": false,
		"ponllo_mission_completed": false,
		
		"gabriella_pickup": 0,
		"gabriella_mission_accepted": false,
		"gabriella_mission_completed": false,
		
		"ignacio_lumberjacks": 0,
		"ignacio_mission_accepted": false,
		"ignacio_mission_completed": false,
		
		"gabriella_pickup2": 0,
		"gabriella_mission_accepted2": false,
		"gabriella_mission_completed2": false,
		
		"angel_pickup": 0,
		"angel_mission_accepted": false,
		"angel_mission_completed": false,
	}
	return quests
	
func loadDialogic() -> void:
	Dialogic.VAR.EnemiesDefeated.emissions_defeated = data.get("quests").get("emissions_defeated")
	Dialogic.VAR.EnemiesDefeated.garbage_defeated = data.get("quests").get("garbage_defeated")
	Dialogic.VAR.EnemiesDefeated.lumberjacks_defeated = data.get("quests").get("lumberjacks_defeated")
	
	Dialogic.VAR.EnemiesDefeated2.emissions_defeated = data.get("quests").get("emissions_defeated2")
	Dialogic.VAR.EnemiesDefeated2.garbage_defeated = data.get("quests").get("garbage_defeated2")
	Dialogic.VAR.EnemiesDefeated2.lumberjacks_defeated = data.get("quests").get("lumberjacks_defeated2")
	
	Dialogic.VAR.MissionAcepted.Luis_Mission.luis_emissions = data.get("quests").get("luis_emissions")
	Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_accepted = data.get("quests").get("luis_mission_accepted")
	Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_completed = data.get("quests").get("luis_mission_completed")
	
	Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_punches_dummy = data.get("quests").get("maritza_punches_dummy")
	Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_dummy = data.get("quests").get("maritza_dummy")
	Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_gas = data.get("quests").get("maritza_gas")
	Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_garbage_picker = data.get("quests").get("maritza_garbage_picker")
	Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_accepted = data.get("quests").get("maritza_mission_accepted")
	Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_completed = data.get("quests").get("maritza_mission_completed")
	
	Dialogic.VAR.MissionAcepted.Mono_Mission.mono_emissions = data.get("quests").get("mono_emissions")
	Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_acepted = data.get("quests").get("mono_mission_acepted")
	Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_completed = data.get("quests").get("mono_mission_completed")
	
	Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_garbage = data.get("quests").get("ponllo_garbage")
	Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_mission_accepted = data.get("quests").get("ponllo_mission_accepted")
	Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_mission_completed = data.get("quests").get("ponllo_mission_completed")

	Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_pickup = data.get("quests").get("gabriella_pickup")
	Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_mission_accepted = data.get("quests").get("gabriella_mission_accepted")
	Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_mission_completed = data.get("quests").get("gabriella_mission_completed")

	Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_lumberjacks = data.get("quests").get("ignacio_lumberjacks")
	Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_mission_accepted = data.get("quests").get("ignacio_mission_accepted")
	Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_mission_completed = data.get("quests").get("ignacio_mission_completed")

	Dialogic.VAR.MissionAcepted.Gabriella_Mission2.gabriella_pickup = data.get("quests").get("gabriella_pickup2")
	Dialogic.VAR.MissionAcepted.Gabriella_Mission2.gabriella_mission_accepted = data.get("quests").get("gabriella_mission_accepted2")
	Dialogic.VAR.MissionAcepted.Gabriella_Mission2.gabriella_mission_completed = data.get("quests").get("gabriella_mission_completed2")
	
	Dialogic.VAR.MissionAcepted.Angel_Mission.angel_pickup = data.get("quests").get("angel_pickup")
	Dialogic.VAR.MissionAcepted.Angel_Mission.angel_mission_accepted = data.get("quests").get("angel_mission_accepted")
	Dialogic.VAR.MissionAcepted.Angel_Mission.angel_mission_completed = data.get("quests").get("angel_mission_completed")

func getTool() -> int:
	return player.player_tool

func getTime() -> String:
	var total_segundos := int(data.get("time"))
	var horas := total_segundos / 3600
	var minutos := (total_segundos % 3600) / 60
	var segundos := total_segundos % 60
	return "%02d:%02d:%02d" % [horas, minutos, segundos]
	
func loadData() -> void:
	load_from_file(slot)
	if not player:
		return
	player.time = data.get("time")
	player.health = data.get("health")
	player.load_position(data["position"])
	player.inventory.from_dict(data["inventory"])
	
func save_to_file() -> void:
	var path = "user://save_slot_%d.save" % slot
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(to_dict()))
		file.close()
	else:
		print("Error al guardar el archivo.")

func save_to_file_filter_i(slotc: int) -> void:
	load_from_file(slotc)
	var path = "user://save_slot_%d.save" % slotc
	var file = FileAccess.open(path, FileAccess.WRITE)

	if file:
		file.store_line(JSON.stringify(saveFilter()))
		file.close()
	else:
		print("Error al guardar el archivo.")

func save_to_file_filter() -> void:
	save_to_file_filter_i(1)
	save_to_file_filter_i(2)
	save_to_file_filter_i(3)
	
func save_to_file_reset() -> void:
	var path = "user://save_slot_%d.save" % slot
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(to_dict_reset()))
		file.close()
	else:
		print("Error al guardar el archivo.")

func load_from_file(slotc: int) -> void:
	slot = slotc
	var path = "user://save_slot_%d.save" % slot
	if not FileAccess.file_exists(path):
		return
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var line = file.get_line()
		var parsed = JSON.parse_string(line)
		file.close()
		if typeof(parsed) == TYPE_DICTIONARY:
			from_dict(parsed)
			time = getTime()
