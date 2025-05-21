extends Area2D

@onready var Enemy_Scene = load("res://scenes/Enemies/Garbage.tscn")
var bool_spawn = false
var spawn_count = 4
var random = RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()

func _process(_delta: float) -> void:
	spawn()

func spawn():
	if spawn_count > 0 and bool_spawn and global.isChatting == false:
		$cooldown.start()
		bool_spawn = false
		var enemy_instance = Enemy_Scene.instantiate()
		enemy_instance.global_position = Vector2(position.x + random.randi_range(-50, 50), position.y + random.randi_range(-50, 50))
		get_tree().current_scene.add_child(enemy_instance)
		print("Enemigo instanciado")


func _on_cooldown_timeout() -> void:
	spawn_count -= 1
	bool_spawn = true


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("enemy") and spawn_count <= 0:
		spawn_count = 4



func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("Se ve en pantalla")
	bool_spawn = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("No se ve en pantalla")
	bool_spawn = false
