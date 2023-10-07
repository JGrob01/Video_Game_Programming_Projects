extends Spatial

var original_speed = 0

func _physics_process(delta):
	rotate_y(PI * 1 / 180)
	pass

func _on_Area_body_entered(body):
	if body.is_in_group("Players"):
		original_speed = GlobalVariables.target_speed
		GlobalVariables.target_speed = min(GlobalVariables.target_speed * 3, GlobalVariables.MAX_FLIGHT_SPEED)
		
		$EffectTimer.start()
		
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
		
		queue_free()
	pass

func _on_EffectTimer_timeout():
	GlobalVariables.target_speed = original_speed
