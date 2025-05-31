extends CanvasLayer

@onready var inventory: InventoryGui = $InventoryGUI
@onready var health_bar = $HeatlhBar
@onready var toolSlot = $ToolSlot
@onready var coords = $coords

func _ready():
	inventory.close()

func _input(event):
	if event.is_action_pressed("openInventory"):
		if inventory.isOpen and !inventory.dragging:
			inventory.close()
			toolSlot.visible = true
		else:
			inventory.open()
			toolSlot.visible = false
