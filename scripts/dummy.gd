extends CharacterBody2D

var can_take_damage = true
var enemy_inattackzone = false

func _physics_process(_delta: float) -> void:
	deal_with_damage()
	
func deal_with_damage():
	if can_take_damage and enemy_inattackzone and global.player_current_attack == true:
			get_node("/root/World/bonk").play()
			can_take_damage = false
			$cooldown.start()
			$AnimatedSprite2D.play("punched")
			$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)
			Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_punches_dummy += 1

func _on_cooldown_timeout() -> void:
	can_take_damage = true
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	$AnimatedSprite2D.play("default")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackArea":
		enemy_inattackzone = true


func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.name == "AttackArea":
		enemy_inattackzone = false
