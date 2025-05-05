extends CharacterBody2D

var enemy_inattack_range = false
var player_inaatack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false # attack in progress

var speed = 100
var normalSpeed = 100
var sprintSpeed = 125
var current_dir = "down"

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health == 0:
		player_alive = false # Aca el jugador muere
		self.queue_free() # De momento
	
func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		
		play_anim(1)
		current_dir = "right"
		velocity.x = speed
		velocity.y = 0
	
	elif Input.is_action_pressed("ui_left"):
		play_anim(1)
		current_dir = "left"
		velocity.x = -speed
		velocity.y = 0
		
	elif Input.is_action_pressed("ui_up"):
		play_anim(1)
		current_dir = "up"
		velocity.x = 0
		velocity.y = -speed
		
	elif Input.is_action_pressed("ui_down"):
		play_anim(1)
		current_dir = "down"
		velocity.x = 0
		velocity.y = speed
		
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if attack_ip == false:
		if dir == "right":
			$AttackArea.position = Vector2(15, 0)
			anim.flip_h = false
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_init")
				
		elif dir == "left":
			$AttackArea.position = Vector2(-15, 0)
			anim.flip_h = true
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_init")
		
		elif dir == "up":
			$AttackArea.position = Vector2(0, -15)
			anim.flip_h = false
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				anim.play("back_init")
		
		elif dir == "down":
			$AttackArea.position = Vector2(0, 15)
			anim.flip_h = false
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				anim.play("front_init")

func player():
	pass



func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"): # Si el objeto que entro tiene esa función
		player_inaatack_range = true
		
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		player_inaatack_range = false

func enemy_attack():
	if player_inaatack_range and enemy_attack_cooldown:
		health = health - 10
		enemy_attack_cooldown = false
		$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
		$attack_cooldown.start()
		print("Vida del jugador: ", health)



func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack") and attack_ip == false:
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func _on_collect_area_area_entered(area):
	if area.has_method("collect"):
		area.collect()
