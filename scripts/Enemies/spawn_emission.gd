extends Area2D

@onready var Enemy_Scene = load("res://scenes/Enemies/emission.tscn")
var bool_spawn = false
var spawn_count = 4
var verifyMono = false
var verifyLuis = false
var random = RandomNumberGenerator.new()

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
	if Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_completed and verifyLuis == false:
		verifyLuis = true
		$cooldown.stop()
		$cooldown.wait_time += 1.5
		print("Se actualizo cooldown")
		$cooldown.start()
	
	if Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_completed and verifyMono == false:
		verifyMono = true
		$cooldown.stop()
		$cooldown.wait_time += 1.5
		print("Se actualizo cooldown")
		$cooldown.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("Se ve en pantalla")
	bool_spawn = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("No se ve en pantalla")
	bool_spawn = false
