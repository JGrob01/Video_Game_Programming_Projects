extends Sprite
#######################################
# Hannah Moats 
# Attached to Sprite, which is a child of 
# CarTemplate scene. Allows the player to choose a custom 
# car sprite, and set a custom car accent and 
# base color using a shader.  
#######################################


#export(Texture) var carSprite
#export(Color) var mainColor 
#export(Color) var accentColor 


#func _ready():
#	texture = carSprite
#	material.set_shader_param("color", mainColor)
#	material.set_shader_param("accent_color", accentColor)

# Uses global set variables to customize the player's car, globals would be set in the car picker on the main menu
func set_player_car_sprite():
	texture = GlobalVariables.car_sprite
	material.set_shader_param("color", GlobalVariables.main_color)
	material.set_shader_param("accent_color", GlobalVariables.accent_color)


# Creates a random car with random colors (these could be really ugly lol)
func set_random_car_sprite():
	# Chooses a random car sprite from the list of sprites
	texture = GlobalVariables.all_car_sprites[rand_range(0, len(GlobalVariables.all_car_sprites))]
	material.set_shader_param("color", get_random_color())
	material.set_shader_param("accent_color", get_random_color())


func get_random_color() -> Color:
	var color = Color(rand_range(0,255)/255, rand_range(0,255)/255, rand_range(0,255)/255,1)
	return color

