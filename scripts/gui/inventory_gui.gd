class_name InventoryGui
extends Control

signal opened
signal closed
signal selectedSlot(slot: InventorySlot)

@onready var player: Player = get_parent().get_parent().get_node("Player")

@onready var inventory: Inventory = preload("res://resources/inventoryResources/playerInventory.tres")
@onready var slots_gui: Array = $Inventory/GridContainer.get_children()
@onready var slots: Array[InventorySlot] = inventory.slots
@onready var hotbar_slots: Array = $Hotbar/GridContainer.get_children()
@onready var index: int = 0
@onready var selected_slot: InventorySlot = inventory.slots[index]
@onready var selected_hotbar_slot: SlotGui = hotbar_slots[index]

@onready var dragPreview: TextureRect = $DragPreview
@onready var dragAmount: Label = $DragPreview/Label
@onready var iconPreview: Sprite2D = null
@onready var amountPreview: int = -1
@onready var namePreview: String = ""
@onready var itemPreview: InventoryItem
@onready var dragging_index: int = -1

var isOpen: bool = false
var on_inventory: bool = false

var dragging: bool = false

func _ready():
	close()
	selected_hotbar_slot.isSelected = true
	inventory.updated.connect(update)
	update()
	_connect_slot_signals()
	emit_signal("selectedSlot", selected_slot)

func _process(_delta: float) -> void:
	if dragging:
		dragPreview.global_position = get_global_mouse_position()

func update():
	for i in range(min(inventory.slots.size(), slots_gui.size())):
		slots_gui[i].index = i
		slots_gui[i].update(inventory.slots[i])
	update_hotbar_slots()

func _connect_slot_signals():
	for slot in slots_gui:
		slot.connect("clicked", Callable(self, "on_slot_clicked"))

func on_slot_clicked(slot_index):
	print("El slot clickeado es el numero: ", slot_index)
	if dragging:
		drop_to_slot(slot_index)
	elif !dragging:
		start_dragging(slot_index)

func _input(event: InputEvent) -> void:
	if !self.isOpen:
		if event is InputEventKey and Input.is_action_just_pressed("change_item"):
			self._update_selected_slot()
			emit_signal("selectedSlot", selected_slot)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and not event.is_echo():
		if !self.on_inventory and self.dragging:
			pass

func start_dragging(slot_index):
	if slot_index < 0 or slot_index > slots.size():
		return 
	
	var slot: InventorySlot = self.slots[slot_index]
	var slot_gui: SlotGui = self.slots_gui[slot_index]
	if slot_gui.onSlot:
		print("Slot a arrastrar: ", slot_gui.index)
		if slot.item:
			print("Item en slot: ", slot.item.name)
			print("Item en slot_gui: ", slot_gui.nameLabel.text)
			self.dragging = true
			global.dragging = true
			self.dragging_index = slot_gui.index
			self.itemPreview = slot.item
			self.amountPreview = slot.amount
			
			slot.item = null
			slot.amount = 0
			inventory.updated.emit()
			
			self.dragPreview.visible = true
			self.dragPreview.texture = itemPreview.texture
			self.dragAmount.text = str(amountPreview)
			dragPreview.global_position = get_global_mouse_position()
		else:
			print("Slot vacio")
		

func drop_to_slot(slot_index):
	if slot_index < 0 or slot_index > slots_gui.size():
		return 
	
	var target_slot: InventorySlot = self.slots[slot_index]
	var target_slot_gui: SlotGui = self.slots_gui[slot_index]
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
				self.dragAmount.text = str(amountPreview)
			else:
				target_slot.amount += amountPreview
				inventory.updated.emit()
				stop_dragging()
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
			self.dragAmount.text = str(amountPreview)

func drop_to_world():
	if dragging and !on_inventory:
		print("Item del slot ", self.dragging_index, " dropeado al mundo")
		stop_dragging()

func stop_dragging():
	self.dragging = false
	global.dragging = false
	self.dragging_index = -1
	self.iconPreview = null
	self.amountPreview = -1
	self.namePreview = ""
	self.dragPreview.visible = false
	self.dragPreview.texture = null
	self.dragAmount.text = "-1"

func open():
	$Inventory.visible = true
	$Hotbar.visible = false
	isOpen = true
	opened.emit()
	
func close():
	$Inventory.visible = false
	$Hotbar.visible = true
	isOpen = false
	closed.emit()

	
func _on_mouse_entered() -> void:
	print("On inventory")
	self.on_inventory = true

func _on_mouse_exited() -> void:
	print("Not on inventory")
	self.on_inventory = false

func update_hotbar_slots():
	for i in range(5):
		hotbar_slots[i].index = i
		hotbar_slots[i].isHotbarSlot = true
		hotbar_slots[i].update(inventory.slots[i])

func _update_selected_slot():
	self.selected_hotbar_slot.isSelected = false
	if Input.is_key_pressed(KEY_RIGHT):
		self._next_index()
	elif Input.is_key_pressed(KEY_LEFT):
		self._previous_index()
		
	self.selected_slot = inventory.slots[index]
	self.selected_hotbar_slot = self.hotbar_slots[index]
	self.selected_hotbar_slot.isSelected = true
	emit_signal("selectedSlot", self.selected_slot)
	self.update()

func _next_index():
	print("Indice actual: ", self.index)
	if self.index == hotbar_slots.size()-1:
		self.index = 0
	else:
		self.index += 1
	print("Nuevo Indice: ", self.index)

func _previous_index():
	print("Indice actual: ", self.index)
	if self.index == 0:
		self.index = hotbar_slots.size()-1
	else:
		self.index -=1
	print("Nuevo Indice: ", self.index)
