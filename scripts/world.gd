class_name World
extends Node2D

@onready var player = $Player
@onready var inventory = $CanvasLayer/InventoryGUI
@onready var healthBar = $CanvasLayer/HeatlhBar

func _ready():
	inventory.opened.connect(_on_inventory_opened)
	inventory.closed.connect(_on_inventory_closed)
	global.player_current_attack = false

func _process(delta: float) -> void:
	healthBar.value = player.get_life()

func _on_inventory_opened():
	get_tree().paused = true
	

func _on_inventory_closed():
	get_tree().paused = false
