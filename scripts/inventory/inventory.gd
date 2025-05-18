extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

func insert(item: InventoryItem):
	
	var find_empty_slot = func():
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	
	var itemSlots = slots.filter(func(slot): return slot.item != null and slot.item.name == item.name)
	if !itemSlots.is_empty() and itemSlots[itemSlots.size()-1].amount < item.maxAmount:
		itemSlots[itemSlots.size()-1].amount += 1
		
	else:
		find_empty_slot.call()
	updated.emit()
	
func to_dict() -> Dictionary:
	var data: Dictionary = {}
	for i in range(slots.size()):
		var slot = slots[i]
		if slot.item != null:
			data[i] = {
				"name": slot.item.name,
				"texture_path": slot.item.texture.resource_path,
				"maxAmount": slot.item.maxAmount,
				"amount": slot.amount
			}
	return data

func from_dict(data: Dictionary) -> void:
	
	for i in data.keys():
		var slot_data = data[i]

		var item = InventoryItem.new()
		item.name = slot_data.get("name")
		item.texture = ResourceLoader.load(slot_data.get("texture_path"))
		item.maxAmount = slot_data.get("maxAmount")
		
		var amount = slot_data.get("amount")

		for j in range(amount):
			insert(item)
