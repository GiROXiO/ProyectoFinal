extends CanvasLayer

@onready var inventory = $InventoryGUI
@onready var health_bar = $HeatlhBar
@onready var toolSlot = $ToolSlot

func _ready():
	inventory.close()

func _input(event):
	if event.is_action_pressed("openInventory"):
		if inventory.isOpen:
			inventory.close()
			toolSlot.visible = true
		else:
			inventory.open()
			toolSlot.visible = false
