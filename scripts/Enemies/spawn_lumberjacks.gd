extends Area2D

@onready var Enemy_Scene = load("res://scenes/Enemies/lumberjack.tscn")
var bool_spawn = false
var spawn_count = 4
var random = RandomNumberGenerator.new()
var verifyPonllo = false

func _ready() -> void:
	random.randomize()

func _process(_delta: float) -> void:
	missionVerifier()
	spawn()

func spawn():	
	spawn_count = $SpawnedEnemies.get_child_count()
	
	if spawn_count <= 3 and bool_spawn and global.isChatting == false:
		$cooldown.start()
		bool_spawn = false
		var enemy_instance = Enemy_Scene.instantiate()
		var spawn_pos = Vector2(position.x + random.randi_range(-50, 50), position.y + random.randi_range(-50, 50))
		enemy_instance.position = $SpawnedEnemies.to_local(spawn_pos)
		$SpawnedEnemies.add_child(enemy_instance)		
		print(spawn_count)
	
	


func _on_cooldown_timeout() -> void:
	spawn_count -= 1
	bool_spawn = true


func missionVerifier():
	pass

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("Se ve en pantalla")
	bool_spawn = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("No se ve en pantalla")
	bool_spawn = false
