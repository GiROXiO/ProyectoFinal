extends Node

class_name ListaDobleCircular
const Nodo = preload("res://scripts/Node.gd")

var PTR: Nodo = null

func insert_node(value):
	var new = Nodo.new(value)
	if PTR == null:
		PTR = new
		PTR.right = PTR
		PTR.left = PTR
	else:
		var last = PTR.left
		last.right = new
		new.left = last
		new.right = PTR
		PTR.left = new
