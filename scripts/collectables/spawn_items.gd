extends Area2D

@export var itemType: ItemType.type
@export var foodType: ItemType.food
@export var organicType: ItemType.organic
@export var recyclableType: ItemType.recyclable
@export var unRecyclableType: ItemType.unrecyclable
@export var sproutsType: ItemType.sprouts
@onready var item_scene
var bool_spawn = true
var spawn_count = 1
@export var limit_spawn: int
@export var cooldown: int = 1
@export var margen: int
var random = RandomNumberGenerator.new()

func _ready() -> void:
	$cooldown.wait_time = cooldown
	match self.itemType:
		ItemType.type.FOOD:
			match self.foodType:
				ItemType.food.CEREZA:
					item_scene = load("res://scenes/items/collectables/Cereza.tscn")
				ItemType.food.MANZANA:
					item_scene = load("res://scenes/items/collectables/Manzana.tscn")
				ItemType.food.MANZANADORADA:
					item_scene = load("res://scenes/items/collectables/ManzanaDorada.tscn")
				ItemType.food.NARANJA:
					item_scene = load("res://scenes/items/collectables/Naranja.tscn")
		#Y luego los otros...
	random.randomize()

func _process(_delta: float) -> void:
	#missionVerifier() La verdad, no creo que sea necesario.
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
	


	


func _on_cooldown_timeout() -> void:
	spawn_count -= 1
	bool_spawn = true
