extends CanvasLayer

@onready var inventory: InventoryGui = $InventoryGUI
@onready var hotbar = $InventoryGUI/Hotbar
@onready var health_bar = $HeatlhBar
@onready var toolSlot = $ToolSlot
@onready var coords = $coords
@onready var submenu = $SubMenuContainer
@onready var submenuBottom = $MenuContainer
@onready var options = $options
@onready var help = $help_menu

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


func _on_sub_menu_pressed() -> void:
	inventory.close()
	submenu.visible = true
	submenuBottom.visible = false
	toolSlot.visible = false
	coords.visible = false
	health_bar.visible = false
	hotbar.visible = false
	get_tree().paused = true


func _on_continuar_pressed() -> void:
	submenu.visible = false
	submenuBottom.visible = true
	toolSlot.visible = true
	coords.visible = true
	health_bar.visible = true
	hotbar.visible = true
	get_tree().paused = false


func _on_configuracion_pressed() -> void:
	options.visible = true
	pass # Replace with function body.


func _on_ayuda_pressed() -> void:
	help.visible = true
	pass # Replace with function body.


func _on_back_start_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
