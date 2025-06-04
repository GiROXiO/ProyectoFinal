extends Area2D

class_name PickupItem

@export var itemRes: InventoryItem
@export var itemType: ItemType.type

func collect(inventory: Inventory):
	var sw: bool = inventory.insert(itemRes)
	if sw:
		queue_free()
