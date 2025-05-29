extends StaticBody2D

func _physics_process(_delta: float) -> void:
	if Dialogic.VAR.MissionAcepted.Maritza_Mision.maritza_mission_completed == true:
		self.queue_free()
