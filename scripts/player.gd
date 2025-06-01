class_name Player
extends CharacterBody2D

signal toolChanged(index:int)
signal usedItem(item: InventoryItem)

@onready var inventory_gui: InventoryGui = get_parent().get_node("GUI/InventoryGUI")
@export var inventory: Inventory = preload("res://resources/inventoryResources/playerInventory.tres")

var enemy_inattack_range = false
var player_inaatack_range = false
var enemy_attack_cooldown = true
var maxHealth = 100
@export var health = maxHealth
var player_alive = true
var selectedSlot: InventorySlot

var is_dashing = false
var can_dash = true
var dash_time = 0.0

var time = 0.0
var attack_ip = false # attack in progress

var speed = 100

const normalSpeed = 100
const sprintSpeed = 125
const dashSpeed = 220

var current_dir = "down"
@export var player_tool = 0
#Respecto a player_tool
#0 = Escoba
#1 = Aspiradora
#2 = Caña

func _ready():
	add_to_group("player")
	emit_signal("toolChanged", player_tool)
	gameData.setPlayer(self)
	gameData.loadData()
	inventory_gui.connect("selectedSlot", Callable(self, "_update_selected_slot"))

func _process(delta):
	time += delta
	
func reset()-> void:
	health = 100
	position = Vector2(3064,1486)
	gameData.save_to_file()

func saveTime()-> float:
	return time
		
func saveHealth()-> int:
	return health
		
func saveWeapon()-> int:
	return player_tool
	
func savePosition() -> Dictionary:
	return {
		"x": position.x,
		"y": position.y
	}

func load_position(data: Dictionary) -> void:
	position = Vector2(data.get("x"), data.get("y"))

func _physics_process(delta):
	if global.isChatting == false and global.another_entity == false:
		player_movement(delta)
		enemy_attack()
		change_tool()
		global.player_position = global_position
	elif global.another_entity:
		enemy_attack()
		play_anim(0)
	attack()
	
	if health == 0:
		player_alive = false # Aca el jugador muere
		self.queue_free() # De momento

func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_action_just_pressed("use_item"):
		self.use_item()
		

func player_movement(_delta):
	gameData.save_to_file()
	if Input.is_action_pressed("Sprint"):
		speed = sprintSpeed
	elif Input.is_action_just_pressed("Dash") and is_dashing == false and can_dash:
		is_dashing = true
		can_dash = false
		$dash_time.start()
		$dash_cooldown.start()
	else:
		speed = normalSpeed
	
	if is_dashing == false:
		if Input.is_key_pressed(KEY_D):
			current_dir = "right"
			play_anim(1)
			velocity.y = 0
			velocity.x = speed
			
		elif Input.is_key_pressed(KEY_A):
			play_anim(1)
			current_dir = "left"
			velocity.x = -speed
			velocity.y = 0
			
		elif Input.is_key_pressed(KEY_W):
			play_anim(1)
			current_dir = "up"
			velocity.x = 0
			velocity.y = -speed
			
		elif Input.is_key_pressed(KEY_S):
			play_anim(1)
			current_dir = "down"
			velocity.x = 0
			velocity.y = speed
			
		else:
			play_anim(0)
			velocity.x = 0
			velocity.y = 0
			
	elif is_dashing and attack_ip == false:
		if current_dir == "right":
			play_anim(2)
			velocity.y = 0
			velocity.x = dashSpeed
			
		elif current_dir == "left":
			play_anim(2)
			velocity.y = 0
			velocity.x = -dashSpeed

		elif current_dir == "up":
			play_anim(2)
			velocity.y = -dashSpeed
			velocity.x = 0
		
		elif current_dir == "down":
			play_anim(2)
			velocity.y = dashSpeed
			velocity.x = 0
			
		pass
	
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	# Respecto a movement
	# 0 = Quieto
	# 1 = Moviendose
	# 2 = Dash
	
	if attack_ip == false:
		if dir == "right":
			anim.flip_h = false
			if player_tool == 0:
				$AttackArea.position = Vector2(15, 0)
			elif player_tool == 1:
				$AttackArea.position = Vector2(50, 0)
				
			if movement == 1:
				anim.play("side_walk")
			elif movement == 2:
				anim.play("side_dash")
			elif movement == 0:
				anim.play("side_init")
				
		elif dir == "left":
			anim.flip_h = true
			if player_tool == 0:
				$AttackArea.position = Vector2(-15, 0)
			elif player_tool == 1:
				$AttackArea.position = Vector2(-50, 0)
				
			if movement == 1:
				anim.play("side_walk")
			elif movement == 2:
				anim.play("side_dash")
			elif movement == 0:
				anim.play("side_init")
		
		elif dir == "up":
			anim.flip_h = false
			if player_tool == 0:
				$AttackArea.position = Vector2(0, -15)
			elif player_tool == 1:
				$AttackArea.position = Vector2(0, -50)
				
			if movement == 1:
				anim.play("back_walk")
			elif movement == 2:
				anim.play("back_dash")
			elif movement == 0:
				anim.play("back_init")
		
		elif dir == "down":
			anim.flip_h = false
			if player_tool == 0:
				$AttackArea.position = Vector2(0, 15)
			elif player_tool == 1:
				$AttackArea.position = Vector2(0, 50)
				
			if movement == 1:
				anim.play("front_walk")
			elif movement == 2:
				anim.play("front_dash")
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
		get_node("/root/World/gas").play()
		health = health - 10
		enemy_attack_cooldown = false
		$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
		$attack_cooldown.start()
		print("Vida del jugador: ", health)
		if health == 0:
			global.player_current_attack = false
			reset()
			get_tree().change_scene_to_file("res://scenes/game_over_scene.tscn")
		else:
			gameData.save_to_file()
	

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	$AnimatedSprite2D.modulate = Color(1, 1, 1)

func attack():
	var dir = current_dir
	
	if can_attack():
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
			
	elif Input.is_action_pressed("attack") and attack_ip == false and global.isChatting == false and player_tool == 1:
		global.player_current_aspire = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			#Basicamente esta parte
			$AnimatedSprite2D.play("side_vacuum")
			$deal_attack_timer.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			#Esta otra
			$AnimatedSprite2D.play("side_vacuum")
			$deal_attack_timer.start()
		elif dir == "down":
			$AnimatedSprite2D.flip_h = false
			#Esta de aqui tambien
			$AnimatedSprite2D.play("front_vacuum")
			$deal_attack_timer.start()
		elif dir == "up":
			$AnimatedSprite2D.flip_h = false
			#Esta de aqui tambien
			$AnimatedSprite2D.play("back_vacuum")
			$deal_attack_timer.start()
	
	elif Input.is_action_just_pressed("attack") and attack_ip == false and global.isChatting == false and player_tool == 2:
		if global.another_entity == false:
			global.another_entity = true
		else:
			global.another_entity = false
			
	if global.isChatting == true:
		attack_ip = false
		if dir == "up":
			$AnimatedSprite2D.play("back_init")
			$AnimatedSprite2D.flip_h = false
		elif dir == "down":
			$AnimatedSprite2D.play("front_init")
			$AnimatedSprite2D.flip_h = false
		elif dir == "right":
			$AnimatedSprite2D.play("side_init")
			$AnimatedSprite2D.flip_h = false
		elif dir == "left":
			$AnimatedSprite2D.play("side_init")
			$AnimatedSprite2D.flip_h = true
	else:
		if global.isChatting == true:
			attack_ip = false
			if dir == "up":
				$AnimatedSprite2D.play("back_init")
				$AnimatedSprite2D.flip_h = false
			elif dir == "down":
				$AnimatedSprite2D.play("front_init")
				$AnimatedSprite2D.flip_h = false
			elif dir == "right":
				$AnimatedSprite2D.play("side_init")
				$AnimatedSprite2D.flip_h = false
			elif dir == "left":
				$AnimatedSprite2D.play("side_init")
				$AnimatedSprite2D.flip_h = true

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	global.player_current_aspire = false
	attack_ip = false

func _on_collect_area_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
		gameData.save_to_file()

func change_tool():
	if Input.is_action_just_pressed("change_tool"):
		if Input.is_key_pressed(KEY_UP):
			previous_tool()
		elif Input.is_key_pressed(KEY_DOWN):
			next_tool()
		print("broom: ",player_tool == 0 )
		print("vacuum: ", player_tool == 1)
		print("caña : ", player_tool == 2)
	change_size_attackArea()

func previous_tool():
	if player_tool == 0:
		player_tool = 2
	else:
		player_tool -= 1
	emit_signal("toolChanged", player_tool)

func next_tool():
	if player_tool == 2:
		player_tool = 0
	else:
		player_tool += 1
	emit_signal("toolChanged", player_tool)

func _update_selected_slot(slot: InventorySlot):
	self.selectedSlot = slot
	if selectedSlot.item:
		print(selectedSlot.item.name)

func use_item():
	if not selectedSlot:
		print("No tiene slot seleccionado")
		return
	if self.selectedSlot.item != null:
		print("Jugador tiene item en el slot")
		print(selectedSlot.item.name )
		
		print("La curacion es de: ", selectedSlot.item.curation)
		
		print("La nueva curacion es de: ", selectedSlot.item.curation)
		if self.health < self.maxHealth:
			print("Puede curarse")
			if self.health + self.selectedSlot.item.curation > self.maxHealth:
				self.health = self.maxHealth
				
			else:
				self.health += self.selectedSlot.item.curation
			print("Vida del jugador aumento a ", self.health)
			self.selectedSlot.amount -=1
			if selectedSlot.amount <= 0:
				self.selectedSlot.item = null
			self.inventory_gui.update()
		else:
			print("El jugador tiene la vida al maximo")
	else:
		print("No tiene ningun item en el slot seleccionado")
	gameData.save_to_file()

func change_size_attackArea():
	#var originaL = $AttackArea/CollisionShape2D.shape
	var rect_shape = RectangleShape2D.new()
	if player_tool == 1:
		var dir = current_dir
		if dir == "right":
			rect_shape.size = Vector2(80,50)
		elif dir == "left":
			rect_shape.size = Vector2(80,50)
		elif dir == "up":
			rect_shape.size = Vector2(50,80)
		elif dir == "down":
			rect_shape.size = Vector2(50,80)
		$AttackArea/CollisionShape2D.shape = rect_shape
	elif player_tool == 0:
		rect_shape.size = Vector2(15,15)
		$AttackArea/CollisionShape2D.shape = rect_shape

func get_life() -> int:
	return health

func can_attack():
	var tutorial_accepted = Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_accepted
	tutorial_accepted = true
	return tutorial_accepted and Input.is_action_just_pressed("attack") and attack_ip == false and global.isChatting == false and player_tool == 0 and is_dashing == false


func _on_dash_time_timeout() -> void:
	is_dashing = false
	

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
