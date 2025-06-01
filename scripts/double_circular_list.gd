class_name ListaDobleCircular
extends Node

const nodo = preload("res://scripts/toolNode.gd")

var PTR: nodo
var FINAL: nodo
var longitud = 0

func _init() -> void:
	self.PTR = null
	self.FINAL = null

func _insert_node(value: InventoryItem):
	var new_node: nodo = nodo.new(value)
	new_node.index = longitud
	
	if PTR == null:
		self.PTR = new_node
		self.FINAL = new_node
	else:
		new_node.left = self.FINAL
		new_node.right = self.PTR
		self.FINAL.right = new_node
		self.PTR.left = new_node
		self.FINAL = new_node
	
	self.longitud += 1
