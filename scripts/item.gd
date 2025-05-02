extends Area2D
class_name Item

@export var nombre: String
@export var stackable: bool = true

func use(target):
	push_error("use() no implementado en " + str(self))
