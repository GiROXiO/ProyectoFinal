extends CanvasLayer

@onready var inventory = $InventoryGUI
@onready var health_bar = $HeatlhBar
func _ready():
	inventory.close()

func _input(event):
	if event.is_action_pressed("openInventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
