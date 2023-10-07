extends Sprite
###############################################
# Attaches to sprite and allows sprite to change textures
# used in animation player in race countdown. 

# Hannah Moats
###############################################


export(Array, Texture) var textures
var current_texture = 0

func _ready():
	texture = textures[current_texture]


func change_to_next_texture():
	current_texture += 1
#	print("Changed texture")
	texture = textures[current_texture]


func set_current_texture(number : int):
	current_texture = number
