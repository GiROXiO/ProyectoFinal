extends CharacterBody2D

var player_in_area = false
var is_roaming = false

func npc():
	pass

func _ready():
	Dialogic.signal_event.connect(DialogicSignal)
	$AnimatedSprite2D.play("default")

func _process(_delta):
	if player_in_area:
		if Input.is_key_pressed(KEY_E) and global.isChatting == false:
			run_dialogue("")
			global.another_entity = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false

func run_dialogue(dialogue_string):
	global.isChatting = true
	is_roaming = false
	Dialogic.start(dialogue_string)

func DialogicSignal(arg: String):
	if arg == "":
		global.isChatting = false
		print("Se ha emitido una señal correctamente")
