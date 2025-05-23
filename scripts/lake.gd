class_name WaterBody
extends Node2D

@onready var water_tiles:TileMapLayer = $Lake
@onready var fishingZones: Node2D = $FishingZone

func _ready() -> void:
	create_fishing_zones()

func create_fishing_zones():
	var base_size : Vector2 = water_tiles.tile_set.tile_size
	var cell_size : Vector2 = base_size * water_tiles.scale
	
	for tile in water_tiles.get_used_cells():
		var tile_id = water_tiles.get_cell_source_id(tile)
		if tile_id == -1:
			continue
		
		var zone = Area2D.new()
		zone.name = "FishingZone_%s_%s" % [tile.x,tile.y]
		zone.collision_layer = 2
		zone.collision_mask = 1
		zone.position = Vector2(tile.x,tile.y)*cell_size + cell_size*0.5
		fishingZones.add_child(zone)
		
		var shape = CollisionShape2D.new()
		var rect  = RectangleShape2D.new()
		rect.extents = cell_size * 0.75
		shape.shape  = rect
		zone.add_child(shape)
		
		zone.body_entered.connect(Callable(self, "_on_fishing_zone_body_entered"))
		zone.body_exited .connect(Callable(self, "_on_fishing_zone_body_exited"))

func _on_fishing_zone_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("Jugador entro en zona de pesca")
		

func _on_fishing_zone_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		print("Jugador salio de zona de pesca")
