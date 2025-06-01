extends Panel

class_name ToolSlotGui

@onready var toolSprite: Sprite2D = $CenterContainer/Panel/Icon
@onready var nameLabel: Label = $CenterContainer/Panel/Name
@onready var toolIcons: Array[InventoryItem] = [preload("res://resources/inventoryResources/items/broom.tres"), preload("res://resources/inventoryResources/items/vacuum.tres"), preload("res://resources/inventoryResources/items/fishingRod.tres")]

var onSlot: bool = false

func _ready():
	self.toolSprite.texture = toolIcons[gameData.getTool()].texture
	self.nameLabel.text = toolIcons[gameData.getTool()].name
	var players = get_tree().get_nodes_in_group("player")
	if players.size()>0:
		var player = players[0]
		player.connect("toolChanged", Callable(self,"changeTool"))

func _process(_delta: float) -> void:
	self.showName()

func changeTool(index: int):
	if index >= 0 and index < toolIcons.size():
		var item = toolIcons[index]
		self.toolSprite.texture = item.texture
		self.nameLabel.text = item.name
	else:
		self.toolSprite.texture = null

func showName():
	if onSlot:
		nameLabel.visible = true
	else:
		nameLabel.visible = false

func _on_mouse_entered() -> void:
	onSlot = true

func _on_mouse_exited() -> void:
	onSlot = false
