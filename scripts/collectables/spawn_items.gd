class_name ItemSpawn
extends Area2D

@export var itemType: ItemType.type
@export var generationType: ItemType.generation
@export var foodType: ItemType.food
@export var organicType: ItemType.organic
@export var recyclableType: ItemType.recyclable
@export var unRecyclableType: ItemType.unrecyclable
@export var sproutsType: ItemType.sprouts
@onready var item_scene
@onready var listScenes = [] 
var bool_spawn = true
var spawn_count = 1

@export var limit_spawn: int
@export var cooldown: int = 1
@export var margen: int
var random = RandomNumberGenerator.new()

func _ready() -> void:
	$cooldown.wait_time = cooldown
	aboutGeneration()
	random.randomize()

func _process(_delta: float) -> void:
	#missionVerifier() La verdad, no creo que sea necesario.
	randomizerItems()
	spawn()

func spawn():
	spawn_count = $itemsSpawned.get_child_count()	
		
	if spawn_count <= limit_spawn and bool_spawn and global.isChatting == false:
		$cooldown.start()
		bool_spawn = false
		var item_instance = item_scene.instantiate()
		var spawn_pos = Vector2(position.x + random.randi_range(-margen, margen), position.y + random.randi_range(-margen, margen))
		item_instance.position = $itemsSpawned.to_local(spawn_pos)
		$itemsSpawned.add_child(item_instance)		
		
		print(spawn_count)

func aboutGeneration():
	match self.itemType:
		ItemType.type.FOOD:
			match self.generationType:
				ItemType.generation.UNIQUE:
					match self.foodType:
						ItemType.food.CEREZA:
							item_scene = preload("res://scenes/items/collectables/Cereza.tscn")
						ItemType.food.MANZANA:
							item_scene = preload("res://scenes/items/collectables/Manzana.tscn")
						ItemType.food.MANZANADORADA:
							item_scene = preload("res://scenes/items/collectables/ManzanaDorada.tscn")
						ItemType.food.NARANJA:
							item_scene = preload("res://scenes/items/collectables/Naranja.tscn")
					#Y luego los otros...
				ItemType.generation.VARIED:
					listScenes.append("res://scenes/items/collectables/Cereza.tscn")
					listScenes.append("res://scenes/items/collectables/Manzana.tscn")
					listScenes.append("res://scenes/items/collectables/ManzanaDorada.tscn")
					listScenes.append("res://scenes/items/collectables/Naranja.tscn")
		ItemType.type.RECYCLABLE:
			match self.generationType:
				ItemType.generation.UNIQUE:
					match self.recyclableType:
						ItemType.recyclable.PLASTICBOTTLE:
							item_scene = preload("res://scenes/items/collectables/BotellaPlastico.tscn")
					#Y luego los otros...
				ItemType.generation.VARIED:
					##Esto no se deberia quedar asi...
					listScenes.append("res://scenes/items/collectables/Cereza.tscn")
					listScenes.append("res://scenes/items/collectables/Manzana.tscn")
					listScenes.append("res://scenes/items/collectables/ManzanaDorada.tscn")
					listScenes.append("res://scenes/items/collectables/Naranja.tscn")

func randomizerItems():
	if listScenes.is_empty():
		pass
	else:
		var randy = random.randi_range(0, 100)
		if randy >=90 :
			item_scene = load(listScenes[2])
		elif randy < 90 and randy >= 60:
			item_scene = load(listScenes[1])
		elif randy < 60 and randy >= 30:
			item_scene = load(listScenes[0])
		elif randy < 30:
			item_scene = load(listScenes[3])
		pass
	pass
func _on_cooldown_timeout() -> void:
	spawn_count -= 1
	bool_spawn = true
