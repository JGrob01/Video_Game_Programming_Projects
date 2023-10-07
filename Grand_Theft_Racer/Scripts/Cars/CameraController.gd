extends Camera2D
#####################################
# Hannah Moats
# Handles camera movement, attaches to 
# a Camera2D object
#####################################


onready var active = false # False if the camera is not active, true if it is
var camera_zoomed_out = false
var t = 0 # Used when zooming out camera out on vehicle 


func set_active_camera(player_car : bool):
	active = player_car
	current = player_car


# Sets camera false if true, sets true if false (so turns it off and on)
func toggle_camera():
	current = not current


func violently_shake_camera_repeatedly(shake_strength : float):
	if active:
		offset = get_camera_offset(shake_strength)




# Offsets the camera at a certain position 
func get_camera_offset(shake_strength : float) -> Vector2:
	return Vector2(
		rand_range(-shake_strength, shake_strength),
		rand_range(-shake_strength, shake_strength)
	)


# /!\ BROKEN DON'T USE /!\
# Makes car sprite jitter when zooming in and out for some reason 
# speed : current speed of vehicle 
# start_zoom : the zoom the camera starts at
# end_zoom : the zoom the camera ends at 
func zoom_camera(delta_time : float, speed : float, start_zoom : Vector2, end_zoom : Vector2):
	if active:
		if speed > 120 and not camera_zoomed_out:
			if $Camera2D.zoom.x >= 1.18:
				camera_zoomed_out = true
				t = 0
			else:
				t += delta_time * 0.1
				$Camera2D.zoom = $Camera2D.zoom.linear_interpolate(end_zoom, t)
		elif speed <= 120 and camera_zoomed_out:
			if $Camera2D.zoom.x <= 1.02:
				camera_zoomed_out = false
				t = 0
			else:
				t += delta_time * 0.1
				$Camera2D.zoom = $Camera2D.zoom.linear_interpolate(end_zoom, t)

