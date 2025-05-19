extends Panel

class_name SlotGui

signal clicked(index)

@onready var backgroundSprite:AnimatedSprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var amountLabel: Label = $CenterContainer/Panel/Amount
@onready var nameLabel: Label = $CenterContainer/Panel/Name

@export var index: int = -1
@export var isHotbarSlot = false
@export var isSelected: bool = false

var onSlot: bool = false

func _ready() -> void:
	backgroundSprite.play("normal")

func _process(_delta: float) -> void:
	self.showNameLabel()

func update(slot: InventorySlot):
	if !slot.item:
		self.itemSprite.visible = false
		self.amountLabel.visible = false
		self.nameLabel.visible = false
	else:
		self.itemSprite.visible = true
		self.itemSprite.texture = slot.item.texture
		self.amountLabel.visible = slot.amount>1
		self.amountLabel.text = str(slot.amount)
		self.nameLabel.text = str(slot.item.name)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and not event.is_echo():
		if onSlot:
			emit_signal("clicked", index)

func showNameLabel():
	if self.onSlot and int(self.amountLabel.text)>0:
		self.nameLabel.visible = true
	else:
		self.nameLabel.visible = false

func _on_mouse_entered() -> void:
	print("On slot")
	onSlot = true

func _on_mouse_exited() -> void:
	print("Not on slot")
	onSlot = false

func _update_hotbar_slot():
	if  isHotbarSlot and isSelected:
		backgroundSprite.play("selected")
	else:
		backgroundSprite.play("normal")
