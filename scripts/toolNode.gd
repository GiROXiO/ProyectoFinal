class_name ToolNode
extends Node

var value: InventoryItem
var left: ToolNode
var right: ToolNode
var index: int = -1

func _init(val: InventoryItem):
	self.value = val
	self.left = null
	self.right = null
