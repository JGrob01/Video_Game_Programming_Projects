extends Spatial

func _physics_process(delta):
	rotate_y(PI * 1 / 180)
	pass

func _on_Area_body_entered(body):
	if body.is_in_group("Players"):
		GlobalVariables.damage += 10
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
		
		queue_free()
	pass
