extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]
var lastSlot: int = 10

func insert(item: InventoryItem) -> bool:
	for slot in slots:
		if slot.item != null and slot.amount < item.maxAmount and slot.item.name == item.name:
			slot.amount += 1
			updated.emit()
			return true
	
	for slot in slots:
		if slot.item == null:
			slot.item = item
			slot.amount += 1
			updated.emit()
			return true
	
	print("Inventario lleno")
	return false

func to_dict() -> Dictionary:
	var data: Dictionary = {}
	for i in range(slots.size()):
		var slot = slots[i]
		if slot.item != null:
			data[i] = {
				"name": slot.item.name,
				"texture_path": slot.item.texture.resource_path,
				"maxAmount": slot.item.maxAmount,
				"amount": slot.amount,
				"curation": slot.item.curation
			}
	return data

func from_dict(data: Dictionary) -> void:
	for i in range(slots.size()):
		var slot = slots[i]
		slot.item = null
		slot.amount = 0
			
	if (not lastSlot==gameData.slot):
		lastSlot = gameData.slot
		for i in data.keys():
			var slot_data = data[i]

			var item = InventoryItem.new()
			item.name = slot_data.get("name")
			item.texture = ResourceLoader.load(slot_data.get("texture_path"))
			item.maxAmount = slot_data.get("maxAmount")
			item.curation = slot_data.get("curation")
			var amount = slot_data.get("amount")

			for j in range(amount):
				insert(item)
