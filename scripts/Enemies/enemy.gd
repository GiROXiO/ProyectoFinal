extends CharacterBody2D

var speed = 65
var player_chase = false
var player = null
var isAlive = true
var health = 1
var player_inattack_zone = false
var enemy_inattackzone = false
var takeDamage = 1
var current_damagin = false
var has_spawn = false

func _ready() -> void:
	$take_damage_cooldown.wait_time = 1.5
	$AnimatedSprite2D.play("spawn")
	$spawn.start()

func _physics_process(_delta: float) -> void:
	if isAlive and has_spawn:
		if global.isChatting == false:
			deal_with_damage()
			
			if player_chase and current_damagin == false:
				global_position += ((player.global_position - global_position) / speed) * takeDamage

				move_and_collide(Vector2(0,0))
				$AnimatedSprite2D.play("walk")
				
				if (player.global_position.x - global_position.x) < 0:
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
					
			elif current_damagin:
				$AnimatedSprite2D.play("death")
				
			else:
				velocity = Vector2.ZERO
				move_and_slide()
				$AnimatedSprite2D.play("idle")
	elif has_spawn == false:
		$AnimatedSprite2D.play("spawn")

func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackArea":
		enemy_inattackzone = true

func _on_enemy_hitbox_area_exited(area: Area2D) -> void:
	if area.name == "AttackArea":
		enemy_inattackzone = false

func _on_detection_area_body_entered(body: Node2D) -> void: 
	player = body # Cualquier cosa que entre al area de detección, sera la variable body
	player_chase = true
	
func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if isAlive:
		if enemy_inattackzone and global.player_current_aspire == true:
			get_node("/root/World/gas").play()
			takeDamage = 0
			
			if current_damagin == false:
				current_damagin = true
				$take_damage_cooldown.start()
				$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
			
		else:
			takeDamage = 1
			$take_damage_cooldown.stop()
			current_damagin = false
			$AnimatedSprite2D.modulate = Color(1, 1, 1)
			

func _on_take_damage_cooldown_timeout() -> void:
	$take_damage_cooldown.stop()
	$CollisionShape2D.disabled = true
	isAlive = false
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	verifyMision()
	self.queue_free()
	
func verifyMision():
	if Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_accepted and Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_completed == false:
		Dialogic.VAR.MissionAcepted.Luis_Mission.luis_emissions += 1
	if Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_acepted and Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_completed == false:
		Dialogic.VAR.MissionAcepted.Mono_Mission.mono_emissions += 1
	Dialogic.VAR.EnemiesDefeated.emissions_defeated += 1

func _on_spawn_timeout() -> void:
	has_spawn = true
