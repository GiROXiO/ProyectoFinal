extends Node2D

@onready var player = $Player
@onready var healthBar = $Player.health
@onready var inventory = $CanvasLayer/InventoryGUI

func _ready():
	inventory.opened.connect(_on_inventory_opened)
	inventory.closed.connect(_on_inventory_closed)
	global.player_current_attack = false


func _on_inventory_opened():
	get_tree().paused = true
	

func _on_inventory_closed():
	get_tree().paused = false
