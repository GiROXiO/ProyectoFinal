extends Resource

class_name InventorySlot

@export var item: InventoryItem
@export var amount: int

func _ready():
	self.maxAmountReached()

func maxAmountReached():
	if self.amount >= self.item.maxAmount:
		self.amount = self.item.maxAmount
