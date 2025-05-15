extends Panel

class_name SlotGui

signal clicked(index)

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var amountLabel: Label = $CenterContainer/Panel/Label

@export var index: int = -1

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
		self.itemSprite.visible = true
		self.itemSprite.texture = slot.item.texture
		self.amountLabel.visible = slot.amount>1
		self.amountLabel.text = str(slot.amount)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and not event.is_echo():
		if onSlot:
			print("Clic en slot")
			emit_signal("clicked", index)

func _on_mouse_entered() -> void:
	print("On slot")
	onSlot = true

func _on_mouse_exited() -> void:
	print("Not on slot")
	onSlot = false
