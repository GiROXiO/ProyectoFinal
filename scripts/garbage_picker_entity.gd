extends CharacterBody2D

@export var inventory: Inventory = preload("res://resources/inventoryResources/playerInventory.tres")
var exist = false
var movement = true
var speed = 130

func _ready() -> void:
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.hide()

func _physics_process(delta):
	if global.another_entity == true:
		if exist == false:
			exist = true
			get_node("/root/World/cuervo").play()
			global_position = get_parent().global_position
			$CollisionShape2D.disabled = false
			$AnimatedSprite2D.show()
			$AnimatedSprite2D.play("default")
		garbage_picker_movement(delta)
	else:
		get_node("/root/World/aleteo").stop()
		exist = false
		global_position = get_parent().global_position
		$CollisionShape2D.disabled = true
		$AnimatedSprite2D.hide()



func garbage_picker_movement(_delta):
	
	if Input.is_key_pressed(KEY_D):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("side_flight")
		velocity.x = speed
		velocity.y = 0
	
	elif Input.is_key_pressed(KEY_A):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_flight")
		velocity.x = -speed
		velocity.y = 0
		
	elif Input.is_key_pressed(KEY_W):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("side_flight")
		velocity.x = 0
		velocity.y = -speed
		
	elif Input.is_key_pressed(KEY_S):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("front_flight")
		velocity.x = 0
		velocity.y = speed
		
	else:
		velocity.x = 0
		velocity.y = 0
		
	if $AnimatedSprite2D.animation != "default" and not get_node("/root/World/aleteo").playing:
		get_node("/root/World/aleteo").play()	
		
	move_and_slide()
		


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	global.another_entity = false


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		var pickup := area as PickupItem
		if pickup.itemType == ItemType.type.RECYCLABLE or pickup.itemType == ItemType.type.UNRECYCLABLE:
			get_node("/root/World/cuervo").play()
			verifyMission()
			area.collect(inventory)
			gameData.save_to_file()

func verifyMission():
	if Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_completed == false:
		Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_garbage_picker += 1
	if Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_mission_accepted:
		Dialogic.VAR.MissionAcepted.Gabriella_Mission.gabriella_pickup += 1
	if Dialogic.VAR.MissionAcepted.Angel_Mission.angel_mission_accepted:
		Dialogic.VAR.MissionAcepted.Angel_Mission.angel_pickup += 1
