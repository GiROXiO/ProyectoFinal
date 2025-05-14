extends Area2D

@onready var Enemy_Scene = load("res://scenes/emision.tscn")
var bool_spawn = true
var spawn_count = 5
var random = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()

func _process(_delta: float) -> void:
	spawn()

func spawn():
	if spawn_count > 0 and bool_spawn:
		$cooldown.start()
		bool_spawn = false
		var enemy_instance = Enemy_Scene.instantiate()
		enemy_instance.global_position = Vector2(random.randi_range(-163, 305), random.randi_range(-96, 164))
		add_child(enemy_instance)
		


func _on_cooldown_timeout() -> void:
	spawn_count -= 1
	bool_spawn = true
