extends Area2D

@export var itemRes: InventoryItem
@export var itemType: ItemType.type
func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()
