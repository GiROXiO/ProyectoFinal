extends CharacterBody2D

var speed = 65
var player_chase = false
var player = null
var current_dir = "up"

var has_spawn = false
var isAlive = true
var health = 60
var player_inattack_zone = false
var enemy_inattackzone = false
var can_take_damage = true
var takeDamage = 1

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
				global_position += ((player.global_position - global_position) / speed) * takeDamage
				
				move_and_collide(Vector2(0,0))
				
				if player.global_position.y - global_position.y < 0:
					current_dir = "up"
				else:
					current_dir = "down"
				
				match current_dir:
					"down":	
						if player_inattack_zone:
							$AnimatedSprite2D.play("front_attack")
						else:
							$AnimatedSprite2D.play("front_walk")
					"up":
						if player_inattack_zone:
							$AnimatedSprite2D.play("back_attack")
						else:
							$AnimatedSprite2D.play("back_walk")
						
				if (player.global_position.x - global_position.x) < 0:
					$AnimatedSprite2D.flip_h = true
				else:
					$AnimatedSprite2D.flip_h = false
					
			else:
				velocity = Vector2.ZERO
				move_and_slide()
				$AnimatedSprite2D.play("front_init")
	elif has_spawn == false:
		$AnimatedSprite2D.play("spawn")
	else:
		$AnimatedSprite2D.play("death")
		pass
		
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
		if can_take_damage and enemy_inattackzone and global.player_current_attack == true:
			health = health - 20
			get_node("/root/World/bonk").play()
			can_take_damage = false
			takeDamage = -1
			$take_damage_cooldown.start()
			$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
			print("Vida del leñador: ", health)
			if health == 0:
				verifyMisions()
				$deathTimer.start()
				$AnimatedSprite2D.play("death")
				$CollisionShape2D.disabled = true
				isAlive = false
				
			
func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	takeDamage = 1
	
func verifyMisions():
	Dialogic.VAR.EnemiesDefeated.lumberjacks_defeated += 1
	if Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_mission_accepted and Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_mission_completed == false:
		Dialogic.VAR.MissionAcepted.Ignacio_Mission.ignacio_lumberjacks += 1

func _on_death_timer_timeout() -> void:
	self.queue_free()


func _on_spawn_timeout() -> void:
	has_spawn = true
