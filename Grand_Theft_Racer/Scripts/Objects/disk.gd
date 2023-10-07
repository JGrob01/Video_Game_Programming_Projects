#Author: John Grobaker
extends Area2D

export(String) var Song
export(Color, RGB) var col

var track = 0

#When disk is initialized, call the animation player to play the spin animation
func _ready():
	var random = RandomNumberGenerator.new()
	
	random.randomize()
	track = random.randi_range(0, len(MusicPlayer.ALL_RADIO_TRACKS) - 1)
	col = calc_color()
	
	$DiscInner.modulate = col

#Signal called when the player body enters the body of the disk
#Play the collect animation and add music to global
func _on_disk_body_entered(body):
	if (body.name == "CarTemplate" and body.player_car):
		$AudioStreamPlayer2D.play()
		$Sprite.visible = false
		$DiscInner.visible = false
		yield($AudioStreamPlayer2D, "finished")
		#TODO ADD SONG TO RADIO
		print(track) 
		MusicPlayer.add_new_track(track)
		queue_free()
		
func calc_color():
	return Color(
		sin(track / 2) + 0.5,
		sin(track / 2 + 2 * PI / 3) + 0.5,
		sin(track / 2 + 4 * PI / 3) + 0.5
	)
