#Author: John Grobaker
extends Area2D

var sound = preload("res://Assets/Sounds/coin.wav")

#When coin is initialized, call the animation player to play the spin animation
func _ready():
	$AnimationPlayer.play("spin")

#Signal called when the player body enters the body of coin
#Play the collect animation and count up the score of the game
func _on_coin_body_entered(body):
	if (body.name == "CarTemplate" and body.player_car):
		#TODO ADD +1 to Coin Count
		$AudioStreamPlayer2D.stream = sound
		$AudioStreamPlayer2D.play()
		$AnimationPlayer.play("collect")
		$"/root/GlobalVariables".coins += 1
		yield($AnimationPlayer, "animation_finished")
		queue_free()
