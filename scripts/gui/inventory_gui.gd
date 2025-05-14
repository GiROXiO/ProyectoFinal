extends Control

signal opened
signal closed
signal onInventory

var isOpen: bool = false
var on_inventory: bool = false

@onready var inventory: Inventory = preload("res://resources/inventoryResources/playerInventory.tres")
@onready var slots_gui: Array = $NinePatchRect/GridContainer.get_children()
@onready var slots: Array = inventory.slots
@onready var dragPreview:= $DragPreview

func _ready():
	close()
	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].index = i
		slots_gui[i].update(inventory.slots[i])

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()

func _on_back_to_start_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")

func _on_mouse_entered() -> void:
	print("On inventory")

func _on_mouse_exited() -> void:
	print("Not on inventory")
