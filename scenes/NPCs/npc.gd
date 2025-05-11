extends CharacterBody2D

var player_in_area = false
var is_chatting = false
var is_roaming = false

func _ready():
	Dialogic.signal_event.connect(DialogicSignal)

func _process(delta):
	if player_in_area:
		if Input.is_key_pressed(KEY_E):
			run_dialogue("luis_timeline")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false

func run_dialogue(dialogue_string):
	is_chatting = true
	is_roaming = false
	Dialogic.start(dialogue_string)

func DialogicSignal(arg: String):
	if arg == "exit_luis":
		print("signal")
