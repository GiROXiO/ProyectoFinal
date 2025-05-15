extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

func _ready():
	pass

func insert(item: InventoryItem):
	var find_empty_slot = func():
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty() and itemSlots[itemSlots.size()-1].amount < item.maxAmount:
		itemSlots[itemSlots.size()-1].amount += 1
	else:
		find_empty_slot.call()
	updated.emit()
