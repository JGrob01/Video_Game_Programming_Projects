#Author: John Grobaker
extends Area2D

#Signal called when the player body enters the body of the wrench
func _on_powerUp_body_entered(body):
	if (body.name == "CarTemplate" and body.player_car):
		$AudioStreamPlayer2D.play()
		body.velocity = body.velocity * 2.5
		$Sprite.visible = false
		yield($AudioStreamPlayer2D, "finished")
		queue_free()
