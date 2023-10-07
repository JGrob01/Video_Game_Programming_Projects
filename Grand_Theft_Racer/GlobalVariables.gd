extends Node

# Game Information.
var time_trial = false
var current_time = 0
var paused = false
var race_over = false # is set to true when the race ends, game_over screen will come up
var previous_scene #stores the file path to the scene which you would like to change back to

# Player Information.
var speed = 0

# Player's Turbo meter
var current_turbo_meter = 0
var MAX_TURBO_METER = 20

# Player's Health 
var health = 100
var MAX_HEALTH_METER = 100
var take_damage = false
var dead = false
# Player receives damage from objects that it runs into at a certain speed 
# Does not gain damage from running into objects that are pickups or pushable

# Player's ranking.
var ranking = 1
var coins = 0

# Car Customizer Variables 
var all_car_sprites = [] # The set of cars the player can choose from 
# The next 4 variables are changed in the car customizer menu (these are just default values for now)
var car_sprite_index = 0
var car_sprite : Texture = load("res://Assets/Cars/CustomCarChoice/Sports-Car-2-stripe-white.png")
#var car_sprite : Texture = load("res://Assets/Cars/CustomCarChoice/Police-Car-1-NOT-CUSTOM.png")
var accent_color : Color = Color(0.1,0.1,0.1,1)
var main_color : Color = Color(0.2,0.6,0.2,1)

func next_car_sprite():
	if (car_sprite_index == len(all_car_sprites) - 1):
		car_sprite_index = 0
	else:
		car_sprite_index += 1
	
	car_sprite = all_car_sprites[car_sprite_index]
	pass

func previous_car_sprite():
	if (car_sprite_index == 0):
		car_sprite_index = len(all_car_sprites) - 1
	else:
		car_sprite_index -= 1
	
	car_sprite = all_car_sprites[car_sprite_index]
	pass

# Player's location.
var player_location = Vector2(0, 0)
var player_rotation = 0

func _ready():
	get_all_car_textures() # scans the Asset/Car/CUstomCarChoice folder for all the sprites in it
	print("Has retreived all car textures")


# Hannah Moats
# Loads all car textures from the car texture folder and adds them to all_car_sprites
func get_all_car_textures():
	var path = "res://Assets/Cars/CustomCarChoice/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break # If get next returns "" there are no more files
		elif not file_name.begins_with(".") and not file_name.ends_with(".import"):
			#get_next() returns a string so this can be used to load the images into an array.
			all_car_sprites.append(load(path + file_name))
	dir.list_dir_end()
	
func save_to_json():
	var data = {
		"time_trial": time_trial,
		"current_time": current_time,
		"current_turbo_meter": current_turbo_meter,
		"health": health,
		"car_sprite_index": car_sprite_index,
		"accent_color": accent_color,
		"main_color": main_color,
		"player_location": player_location,
		"player_rotation": player_rotation,
		"coins": coins
	}
	var file = File.new()
	
	file.open("user://save.json", File.WRITE)
	file.store_string(to_json(data))
	file.close()
	pass

func read_from_json():
	var file = File.new()
	
	file.open("user://save.json", File.READ)
	
	if file.file_exists("user://save.json"):
		var data = parse_json(file.get_as_text())
		
		if ("time_trail" in data):
			time_trial = bool(data["time_trial"])
		
		if ("current_time" in data):
			current_time = float(data["current_time"])
		
		if ("current_turbo_meter" in data):
			current_turbo_meter = float(data["current_turbo_meter"])
		
		if ("health" in data):
			health = float(data["health"])
		
		if ("car_sprite_index" in data):
			car_sprite_index = int(data["car_sprite_index"])
		car_sprite = all_car_sprites[car_sprite_index]
		
		var col
		
		
		if ("accent_color" in data):
			col = str(data["accent_color"]).split(",")
			accent_color = Color(float(col[0]), float(col[1]), float(col[2]))
		
		if ("main_color" in data):
			col = str(data["main_color"]).split(",")
			main_color = Color(float(col[0]), float(col[1]), float(col[2]))
		
		var pos
		
		if ("player_location" in data):
			pos = str(data["player_location"]).replace("(", "").replace(")", "").split(",")
			player_location = Vector2(float(pos[0]), float(pos[1]))
		
		if ("player_rotation" in data):
			player_rotation = float(data["player_rotation"])
			
		if ("coins" in data):
			coins = int(data["coins"])
	else:
		time_trial = false
		current_time = 0
		current_turbo_meter = 0
		health = MAX_HEALTH_METER
		car_sprite_index = 8
		car_sprite = all_car_sprites[car_sprite_index]
		accent_color = Color(0.1,0.1,0.1,1)
		main_color = Color(0.2,0.6,0.2,1)
		player_rotation = 0
		coins = 0
		
	file.close()
