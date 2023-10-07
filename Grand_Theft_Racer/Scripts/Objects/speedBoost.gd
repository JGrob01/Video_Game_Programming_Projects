#Author: John Grobaker
extends Area2D

#Signal called when the player body enters the body of the wrench
func _on_speedBoost_body_entered(body):
	if (body.name == "CarTemplate" and body.player_car):
		$AudioStreamPlayer2D.play()
		if  body.current_turbo_meter >= 10:
			 body.current_turbo_meter = 20
		else:
			 body.current_turbo_meter += 10
		$Sprite.visible = false
		yield($AudioStreamPlayer2D, "finished")
		queue_free()
