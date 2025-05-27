extends Area2D

@onready var Enemy_Scene = load("res://scenes/Enemies/Garbage.tscn")
var bool_spawn = false
var spawn_count = 0
var random = RandomNumberGenerator.new()
var verifyMaritza = false
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
		#get_tree().current_scene.add_child(enemy_instance)
		print("VISIBLE:", enemy_instance.visible)
		print("MODULATE:", enemy_instance.modulate)
		print("SCALE:", enemy_instance.scale)
		print("Dentro del árbol:", enemy_instance.is_inside_tree())
		print("$SpawnedEnemies is inside tree: ", $SpawnedEnemies.is_inside_tree())

		print(spawn_count)
	

func _on_cooldown_timeout() -> void:
	bool_spawn = true
	
func missionVerifier():
	if Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_completed and verifyMaritza == false:
		verifyMaritza = true
		$cooldown.stop()
		$cooldown.wait_time += 1.5
		print("Se actualizo cooldown")
		$cooldown.start()
		
	if Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_mission_completed and verifyPonllo == false:
		verifyPonllo = true
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
