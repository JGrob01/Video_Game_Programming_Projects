#Author: John Grobaker
extends Area2D

#Signal called when the player body enters the body of the oil
func _on_oil_body_entered(body):
	if (body.name == "CarTemplate" and body.player_car):
		body.velocity = body.velocity/5
		queue_free()
