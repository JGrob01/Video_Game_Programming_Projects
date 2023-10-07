extends Node2D

##########################################
# Hannah Moats
# for testing purposes, makes an object follow
# the mouse.
#########################################

func _process(delta):
	global_position = get_global_mouse_position()
