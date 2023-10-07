#Author: John Grobaker
extends Area2D

#Signal called when the player body enters the body of the wrench
func _on_wrench_body_entered(body):
	if (body.name == "CarTemplate" and body.player_car):
		$AudioStreamPlayer2D.play(.5)
		if GlobalVariables.health >= 75:
			GlobalVariables.health = 100
		else:
			GlobalVariables.health += 25
		$Sprite.visible = false
		yield($AudioStreamPlayer2D, "finished")
		queue_free()
