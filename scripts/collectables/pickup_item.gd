extends Area2D

@export var itemRes: InventoryItem
@export var itemType: ItemType.type
func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()

func use_item():
	match itemType:
		ItemType.type.FOOD:
			var player = $Player
			if self.name == "pocionVidaM":
				player.health += 30
			elif self.name == "pocionVidaG":
				player.health += 50
		#Aqui siguen pero por el momento solo estan estos
	
	#Y luego ese objeto desaparece del inventario, aunque eso es con una funcion del inventario o algo del estilo
