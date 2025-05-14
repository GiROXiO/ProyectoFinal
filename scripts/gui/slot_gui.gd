extends Panel

class_name SlotGui

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var amountLabel: Label = $CenterContainer/Panel/Label

var onSlot: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(slot: InventorySlot):
	if !slot.item:
		itemSprite.visible = false
		amountLabel.visible = false
	else:
		itemSprite.visible = true
		itemSprite.texture = slot.item.texture
		amountLabel.visible = slot.amount>1
		amountLabel.text = str(slot.amount)

func dragging(index: int):
	pass

func _on_mouse_entered() -> void:
	print("On slot")
	onSlot = true

func _on_mouse_exited() -> void:
	print("Not on slot")
	onSlot = false
