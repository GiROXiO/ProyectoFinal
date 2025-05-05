extends Node2D

@onready var player = $Player
@onready var inventory = $CanvasLayer/InventoryGUI

func _ready():
	inventory.opened.connect(_on_inventory_opened)
	inventory.closed.connect(_on_inventory_closed)


func _on_inventory_opened():
	get_tree().paused = true
	

func _on_inventory_closed():
	get_tree().paused = false
