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
	if Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_gas == true:
		self.queue_free()
	$take_damage_cooldown.wait_time = 1.5
	$AnimatedSprite2D.play("spawn")
	$spawn.start()
	

func _physics_process(_delta: float) -> void:
	if isAlive and has_spawn:
		if global.isChatting == false:
			deal_with_damage()
			if current_damagin:
				$AnimatedSprite2D.play("death")
			else:
				$AnimatedSprite2D.play("idle")
			
	elif has_spawn == false:
		$AnimatedSprite2D.play("spawn")

func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackArea":
		enemy_inattackzone = true
		
func _on_enemy_hitbox_area_exited(area: Area2D) -> void:
	if area.name == "AttackArea":
		enemy_inattackzone = false

func deal_with_damage():
	if isAlive:
		if enemy_inattackzone and global.player_current_aspire == true:
			get_node("/root/World/gas").play()			
			if current_damagin == false:
				current_damagin = true
				$take_damage_cooldown.start()
				$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
			
		else:
			$take_damage_cooldown.stop()
			current_damagin = false
			$AnimatedSprite2D.modulate = Color(1, 1, 1)
			

func _on_take_damage_cooldown_timeout() -> void:
	$take_damage_cooldown.stop()
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	has_spawn = false
	Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_gas = true
	self.queue_free()


func _on_spawn_timeout() -> void:
	has_spawn = true
