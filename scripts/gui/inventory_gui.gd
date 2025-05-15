extends Control

class_name InventoryGui

signal opened
signal closed

var isOpen: bool = false
var on_inventory: bool = false

@onready var inventory: Inventory = preload("res://resources/inventoryResources/playerInventory.tres")
@onready var slots_gui: Array = $NinePatchRect/GridContainer.get_children()
@onready var slots: Array = inventory.slots

@onready var dragPreview:= $DragPreview
@onready var iconPreview: Sprite2D = null
@onready var amountPreview: int = -1
@onready var dragging_index: int = -1

var dragging: bool = false

func _ready():
	close()
	inventory.updated.connect(update)
	update()
	_connect_slot_signals()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots_gui[i].index = i
		slots_gui[i].update(inventory.slots[i])

func _connect_slot_signals():
	for slot in slots_gui:
		slot.connect("clicked", Callable(self, "on_slot_clicked"))

func on_slot_clicked(index):
	print("El slot clickeado es el numero: ", index)
	if dragging:
		drop_to_slot(index)
	elif !dragging:
		start_dragging(index)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and not event.is_echo():
		if !self.on_inventory and self.dragging:
			drop_to_world()

func start_dragging(index):
	if index < 0 or index > slots_gui.size():
		return 
	
	var slot_gui: SlotGui = slots_gui[index]
	if slot_gui.onSlot:
		print("Slot a arrastrar: ", slot_gui.index)
		dragging = true
		dragging_index = slot_gui.index

func drop_to_slot(index):
	if index < 0 or index > slots_gui.size():
		return 
	
	var target_slot: SlotGui = slots_gui[index]
	if target_slot.onSlot and self.dragging:
		print("Intercambio entre slot ", dragging_index, " y slot ", target_slot.index)
		stop_dragging()

func drop_to_world():
	if dragging and !on_inventory:
		print("Item del slot ", self.dragging_index, " dropeado al mundo")
		stop_dragging()

func stop_dragging():
	dragging = false

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
	self.on_inventory = true

func _on_mouse_exited() -> void:
	print("Not on inventory")
	self.on_inventory = false
