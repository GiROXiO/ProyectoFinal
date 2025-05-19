extends CharacterBody2D

var speed = 65
var player_chase = false
var player = null
var isAlive = true
var health = 60
var player_inattack_zone = false
var enemy_inattackzone = false
var can_take_damage = true
var takeDamage = 1

func _physics_process(_delta: float) -> void:
	if isAlive:
		if global.isChatting == false:
			deal_with_damage()
			
			if player_chase:
				position += ((player.position - position) / speed) * takeDamage

				move_and_collide(Vector2(0,0))
				$AnimatedSprite2D.play("walk")
				
				if (player.position.x - position.x) < 0:
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
			else:
				velocity = Vector2.ZERO
				move_and_slide()
				$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("death")

func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackArea":
		enemy_inattackzone = true
		print("Entro")
	else:
		print(area.name)
func _on_enemy_hitbox_area_exited(area: Area2D) -> void:
	if area.name == "AttackArea":
		enemy_inattackzone = false
		print("Salio")

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
		
		if can_take_damage and enemy_inattackzone and global.player_current_attack == true:
			health = health - 20
			get_node("/root/World/bonk").play()
			can_take_damage = false
			takeDamage = -1
			$take_damage_cooldown.start()
			$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
			print("Vida de la emision: ", health)
			if health == 0:
				$CollisionShape2D.disabled = true
				$deathTimer.start()
				isAlive = false
				if Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_accepted and Dialogic.VAR.MissionAcepted.Luis_Mission.luis_mission_completed == false:
					Dialogic.VAR.MissionAcepted.Luis_Mission.luis_emissions += 1
				if Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_acepted and Dialogic.VAR.MissionAcepted.Mono_Mission.mono_mission_completed == false:
					Dialogic.VAR.MissionAcepted.Mono_Mission.mono_emissions += 1
				Dialogic.VAR.EnemiesDefeated.emissions_defeated += 1
				print(Dialogic.VAR.EnemiesDefeated.emissions_defeated)
			
func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	takeDamage = 1



func _on_death_timer_timeout() -> void:
	self.queue_free()
