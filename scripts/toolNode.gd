class_name ToolNode
extends Node

var value: InventoryItem
var left: ToolNode
var right: ToolNode
var index: int = -1

func _init(value):
	self.value = value
	self.left = null
	self.right = null
