extends AudioStreamPlayer2D
#####################################
# Hannah Moats
# Attaches to an audioplayer, handles
# playing car engine sounds and toggling
# the sound on and off.
#####################################

#If you want the sound to play automatically, make sure you check autoplay

export var max_volume = 0 # the maximum volume of the sound

func adjust_car_engine_sound(current_speed : float, max_speed : float):
	# Speed ranges from 0 to 195
	# pitch : speed of 0 is pitch of 0, and max_speed of 195 is pitch of 1
	var ratio = current_speed / max_speed
	if ratio <= 0:
		pitch_scale = 0.01
	else:
		pitch_scale = tanh(2 * ratio) # f(x) = tanh(2 * x) creates a sigmoid function /s curve
		# fast pitch increase, and then platues


func toggle_sound(start : float):
	if playing:
		stop()
	else:
		if start == -1: # plays where it left off
			play()
		else:
			play(start) # else plays at particular start position
