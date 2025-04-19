extends Control

var selectedSlot := 0

func _ready():
	updateInfo(1)
	updateInfo(2)
	updateInfo(3)
	$CenterContainer/VBoxContainer/HBoxContainer/Info1.pressed.connect(slot1Pressed)
	$CenterContainer/VBoxContainer/HBoxContainer2/Info2.pressed.connect(slot2Pressed)
	$CenterContainer/VBoxContainer/HBoxContainer3/Info3.pressed.connect(slot3Pressed)

	$CenterContainer/VBoxContainer/HBoxContainer/Delete1.pressed.connect(slot1Deleted)
	$CenterContainer/VBoxContainer/HBoxContainer2/Delete2.pressed.connect(slot2Deleted)
	$CenterContainer/VBoxContainer/HBoxContainer3/Delete3.pressed.connect(slot3Deleted)

	$NewUsernamePanel/VBoxContainer/ConfirmButton.pressed.connect(confirmName)

func slot1Pressed(): slotSelection(1)
func slot2Pressed(): slotSelection(2)
func slot3Pressed(): slotSelection(3)

func slot1Deleted(): deleteSave(1)
func slot2Deleted(): deleteSave(2)
func slot3Deleted(): deleteSave(3)

func updateInfo(slot: int):
	var path = "user://save_slot_%d.save" % slot
	var button_node: Button = null

	match slot:
		1:
			button_node = $CenterContainer/VBoxContainer/HBoxContainer/Info1
		2:
			button_node = $CenterContainer/VBoxContainer/HBoxContainer2/Info2
		3:
			button_node = $CenterContainer/VBoxContainer/HBoxContainer3/Info3

	# 🔧 Tamaño fijo y sin expansión (Godot 4)
	button_node.custom_minimum_size = Vector2(200, 40)
	button_node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button_node.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	button_node.clip_text = true

	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var data = file.get_line()
		var dataLoaded = JSON.parse_string(data)
		file.close()

		if typeof(dataLoaded) == TYPE_DICTIONARY:
			button_node.text = "%s - Nivel %s" % [dataLoaded["username"], str(int(dataLoaded["level"]))]
			button_node.tooltip_text = button_node.text
		else:
			button_node.text = "Error al leer"
	else:
		button_node.text = "Nuevo juego"

		
func slotSelection(slot: int):
	selectedSlot = slot
	var data = loadGame(slot)
	if data.is_empty():
		$NewUsernamePanel.visible = true
		$CenterContainer.visible= false
	else:
		#print("Ranura", slot, "cargada. Jugador:", data["username"])
		showInfo("Datos cargados del jugador %s (Nivel %d)" % [data["username"], data["level"]])

func confirmName():
	var username = $NewUsernamePanel/VBoxContainer/UsernameInput.text.strip_edges()
	if username == "":
		showInfo("Escribe un nombre de usuario valido")
		return

	var data = {
		"username": username,
		"level": int(1)
	}
	
	saveGame(selectedSlot, data)
	$NewUsernamePanel.visible = false
	$NewUsernamePanel/VBoxContainer/UsernameInput.text = ""
	showInfo("Guardado como '%s' en la ranura %d" % [username, selectedSlot])

func saveGame(slot: int, data: Dictionary):
	var path = "user://save_slot_%d.save" % slot
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()

func loadGame(slot: int) -> Dictionary:
	var path = "user://save_slot_%d.save" % slot
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_line()
	var dataLoaded = JSON.parse_string(data)
	file.close()
	if dataLoaded:
		return dataLoaded
	else:
		return {}

func deleteSave(slot: int):
	var path = "user://save_slot_%d.save" % slot
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		showInfo("Ranura %d eliminada." % slot)
		updateInfo(slot)
	else:
		showInfo("No hay nada que borrar en ranura %d." % slot)

func showInfo(text: String):
	$InfoLabel.text = text


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
