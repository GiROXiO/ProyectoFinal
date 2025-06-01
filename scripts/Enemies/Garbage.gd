extends CharacterBody2D

var speed = 75
var player_chase = false
var player = null
var isAlive = true
var health = 60
var player_inattack_zone = false
var enemy_inattackzone = false
var can_take_damage = true
var takeDamage = 1
var current_dir = "down"
var has_spawn = false

func _ready() -> void:
	$take_damage_cooldown.wait_time = 0.5
	$AnimatedSprite2D.play("spawn")
	$spawn.wait_time = 0.8
	$spawn.start()
	
func _physics_process(_delta: float) -> void:
	if isAlive and has_spawn:
		if global.isChatting == false:
			deal_with_damage()
			if player_chase:
				
				if player.global_position.y - global_position.y < 0:
					current_dir = "up"
				else:
					current_dir = "down"
					
				global_position += ((player.global_position - global_position) / speed) * takeDamage
				move_and_collide(Vector2(0,0))
				
				if current_dir == "up":
					$AnimatedSprite2D.play("back_walk")
				else:
					$AnimatedSprite2D.play("front_walk")
					
				if (player.global_position.x - global_position.x) < 0:
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
					
			else:
				velocity = Vector2.ZERO
				move_and_slide()
				if current_dir == "up":
					$AnimatedSprite2D.play("back_idle")
				else:
					$AnimatedSprite2D.play("front_idle")
	elif has_spawn == false:
		$AnimatedSprite2D.play("spawn")

	elif isAlive == false:
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
	if isAlive and has_spawn:
		if can_take_damage and enemy_inattackzone and global.player_current_attack == true:
			health = health - 20
			get_node("/root/World/bonk").play()
			can_take_damage = false
			takeDamage = -2
			$take_damage_cooldown.start()
			$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
			print("Vida de la basura: ", health)
			if health == 0:
				$CollisionShape2D.disabled = true
				$deathTimer.start()
				isAlive = false
				verifyMisions()
			
func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	takeDamage = 1

func verifyMisions():
	Dialogic.VAR.EnemiesDefeated.garbage_defeated += 1
	if Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_mission_accepted and Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_mission_completed == false:
		Dialogic.VAR.MissionAcepted.Ponllo_Mission.ponllo_garbage += 1


func _on_death_timer_timeout() -> void:
	self.queue_free()


func _on_spawn_timeout() -> void:
	has_spawn = true
