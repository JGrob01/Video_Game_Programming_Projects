extends Control
##############################################
# Queries player if they would like to enter an 
# area/change scenes.
#
# Hannah Moats
##############################################


#export var change_to_scene := NodePath()
var change_to_scene # will be set by the area2d node triggering the menu


func _on_NoButton_pressed():
	visible = false


func _on_YesButton_pressed():
	get_tree().change_scene(change_to_scene)
	reset_global()


# Andrew
func reset_global():
	GlobalVariables.dead = false
	GlobalVariables.race_over = false
	GlobalVariables.time_trial = false
	GlobalVariables.current_time = 0
	GlobalVariables.current_turbo_meter = 0
	GlobalVariables.health = GlobalVariables.MAX_HEALTH_METER
	GlobalVariables.car_sprite_index = 8
	GlobalVariables.car_sprite = GlobalVariables.all_car_sprites[GlobalVariables.car_sprite_index]
	GlobalVariables.player_location = Vector2(0, 0)
	GlobalVariables.player_rotation = 0
	GlobalVariables.coins = 0
	GlobalVariables.save_to_json()
	pass
