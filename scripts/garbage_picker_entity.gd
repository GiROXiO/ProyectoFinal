extends CharacterBody2D

@onready var Enemy_Scene = load("res://scenes/garbage_picker_entity.tscn")
var exist = false
var movement = true
var speed = 100

func _ready() -> void:
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.hide()


func _physics_process(delta):
	if global.another_entity == true:
		if exist == false:
			exist = true
			global_position = get_parent().global_position
			$CollisionShape2D.disabled = false
			$AnimatedSprite2D.show()
			$AnimatedSprite2D.play("default")
		garbage_picker_movement(delta)
		
		
	else:
		exist = false
		$CollisionShape2D.disabled = true
		$AnimatedSprite2D.hide()



func garbage_picker_movement(_delta):
	
	if Input.is_key_pressed(KEY_D):
		
		$AnimatedSprite2D.play("default")
		velocity.x = speed
		velocity.y = 0
	
	elif Input.is_key_pressed(KEY_A):
		$AnimatedSprite2D.play("default")
		velocity.x = -speed
		velocity.y = 0
		
	elif Input.is_key_pressed(KEY_W):
		$AnimatedSprite2D.play("default")
		velocity.x = 0
		velocity.y = -speed
		
	elif Input.is_key_pressed(KEY_S):
		$AnimatedSprite2D.play("default")
		velocity.x = 0
		velocity.y = speed
		
	else:
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()
		


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	global.another_entity = false
