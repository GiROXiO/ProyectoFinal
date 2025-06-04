extends SubViewportContainer

func _ready() -> void:
	visible = false

func _process(_delta) -> void:
	if Input.is_action_just_pressed("show_minimap"):
		visible = not visible
