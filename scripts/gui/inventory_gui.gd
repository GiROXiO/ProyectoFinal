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
@onready var namePreview: String = ""
@onready var itemPreview: InventoryItem
@onready var dragging_index: int = -1

var dragging: bool = false

func _ready():
	close()
	inventory.updated.connect(update)
	update()
	_connect_slot_signals()

func _process(_delta: float) -> void:
	if dragging:
		dragPreview.global_position = get_global_mouse_position()

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
	if index < 0 or index > slots.size():
		return 
	
	var slot: InventorySlot = self.slots[index]
	var slot_gui: SlotGui = self.slots_gui[index]
	if slot_gui.onSlot:
		print("Slot a arrastrar: ", slot_gui.index)
		if slot.item:
			print("Item en slot: ", slot.item.name)
			print("Item en slot_gui: ", slot_gui.nameLabel.text)
			self.dragging = true
			self.dragging_index = slot_gui.index
			self.itemPreview = slot.item
			self.amountPreview = slot.amount
			
			slot.item = null
			slot.amount = 0
			inventory.updated.emit()
			
			self.dragPreview.visible = true
			self.dragPreview.texture = itemPreview.texture
			dragPreview.global_position = get_global_mouse_position()
		else:
			print("Slot vacio")
		

func drop_to_slot(index):
	if index < 0 or index > slots_gui.size():
		return 
	
	var target_slot: InventorySlot = self.slots[index]
	var target_slot_gui: SlotGui = self.slots_gui[index]
	if target_slot_gui.onSlot and self.dragging:
		print("Intercambio entre slot ", dragging_index, " y slot ", target_slot_gui.index)
		if target_slot.item == null:
			target_slot.item = itemPreview
			target_slot.amount = amountPreview
			inventory.updated.emit()
			stop_dragging()
		elif target_slot.item.name == itemPreview.name:
			if (target_slot.amount + amountPreview) > target_slot.item.maxAmount:
				var amountDelta = abs(target_slot.item.maxAmount - target_slot.amount)
				target_slot.amount += amountDelta
				inventory.updated.emit()
				amountPreview -= amountDelta
			else:
				target_slot.amount += amountPreview
		else:
			var itemTemp: InventoryItem = target_slot.item
			var amountTemp: int = target_slot.amount
			
			target_slot.item = itemPreview
			target_slot.amount = amountPreview
			inventory.updated.emit()
			
			self.itemPreview = itemTemp
			self.amountPreview = amountTemp
			self.dragging_index = target_slot_gui.index
			self.dragPreview.texture = itemPreview.texture

func drop_to_world():
	if dragging and !on_inventory:
		print("Item del slot ", self.dragging_index, " dropeado al mundo")
		stop_dragging()

func stop_dragging():
	self.dragging = false
	self.dragging_index = -1
	self.iconPreview = null
	self.amountPreview = -1
	self.namePreview = ""
	self.dragPreview.visible = false
	self.dragPreview.texture = null

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
