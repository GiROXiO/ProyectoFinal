extends Item
class_name ConsumableItem

@export var health_restore: int = 0
@export var is_harmful: bool = false

func use(target):
	target.heal(health_restore)
