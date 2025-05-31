extends Node
class_name GameData

var data: Dictionary 
var slot: int = 0
var mute: int= 0  
var username: String = ""
var level: int
var health: int = 100
var weapon: int = 0
@export var inventory: Inventory
@export var player: Player

func reset_data():
	username = ""
	level = 1

func to_dict() -> Dictionary:
	
	return {
		"weapon": player.saveWeapon(),
		"username": username,
		"level": level,
		"health": player.saveHealth(),
		"inventory": inventory.to_dict(),
		"position": player.savePosition()
	}
	
func to_dict_reset() -> Dictionary:
	return {
		"weapon": weapon,
		"username": username,
		"level": level,
		"health": health,
		"inventory": {},
		"position": {
						"x": 3064,
						"y": 1486
					}
	}

func from_dict(dat: Dictionary) -> void:
	data = dat
	username = data.get("username")
	level = data.get("level")
	mute = data.get("mute",0)

func loadInventory() -> void:
	load_from_file(slot)
	if not data.has("inventory"):
		return
	if not inventory:
		return
	inventory.from_dict(data["inventory"])

func loadHealth() -> int:
	load_from_file(slot)
	if not player:
		return health
	if not data.has("health"):
		return health
	health = data.get("health")
	return health

func loadPosition() -> void:
	load_from_file(slot)
	if not data.has("position"):
		return
	if not player:
		return
	player.load_position(data["position"])
	
func loadWeapon() -> int:
	load_from_file(slot)
	if not player:
		return weapon
	if not data.has("weapon"):
		return weapon
	weapon = data.get("weapon")
	return weapon
	
func save_to_file() -> void:
	var path = "user://save_slot_%d.save" % slot
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(to_dict()))
		file.close()
	else:
		print("Error al guardar el archivo.")

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
		reset_data()
		return
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var data = file.get_line()
		var parsed = JSON.parse_string(data)
		file.close()
		if typeof(parsed) == TYPE_DICTIONARY:
			from_dict(parsed)
		else:
			reset_data()
	else:
		reset_data()

func setInventory(inv: Inventory) -> void:
	inventory = inv
	
func setPlayer(pl: Player) -> void:
	player = pl
