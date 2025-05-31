extends SubViewportContainer

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("show_minimap"):
		visible = not visible
