class_name ToolSlotGui
extends Panel

const double_circular_list = preload("res://scripts/double_circular_list.gd")

@onready var toolSprite: Sprite2D = $CenterContainer/Panel/Icon
@onready var nameLabel: Label = $CenterContainer/Panel/Name

var toolIcons: double_circular_list
var currentNode: ToolNode

var onSlot: bool = false

func _ready():
	self.toolIcons = double_circular_list.new()
	self.toolIcons._insert_node(preload("res://resources/inventoryResources/items/broom.tres"))
	self.toolIcons._insert_node(preload("res://resources/inventoryResources/items/vacuum.tres"))
	self.toolIcons._insert_node(preload("res://resources/inventoryResources/items/vulture.tres"))
	
	currentNode = toolIcons.PTR
	
	update_icon()
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size()>0:
		var player = players[0]
		player.connect("toolChanged", Callable(self,"changeTool"))

func _process(_delta: float) -> void:
	self.showName()

func changeTool(dir: String):
	if dir == "left":
		self.currentNode = currentNode.left
	elif dir == "right":
		self.currentNode = currentNode.right
	update_icon()

func update_icon():
	var item: InventoryItem = currentNode.value
	self.toolSprite.texture = item.texture
	self.nameLabel.text = item.name 

func showName():
	if onSlot:
		nameLabel.visible = true
	else:
		nameLabel.visible = false

func _on_mouse_entered() -> void:
	onSlot = true

func _on_mouse_exited() -> void:
	onSlot = false
