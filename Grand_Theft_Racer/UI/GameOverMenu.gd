extends Control

func _ready():
	MusicPlayer.pause()
	
	if GlobalVariables.dead:
		$CenterContainer/VBoxContainer/Label.text = "Oh no! You crashed!"
	else:
		$CenterContainer/VBoxContainer/Label.text = "Welcome to the finish line!"
		
	$CenterContainer/VBoxContainer/ScoreLabel.text = "Score: " + str(10 - GlobalVariables.ranking + GlobalVariables.coins)
	pass

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

func _on_PlayAgainButton_pressed():
#	get_tree().change_scene("res://Scenes/RaceTrack_1.tscn")
	get_tree().change_scene(GlobalVariables.previous_scene) #loads the scene you died in
	reset_global()
	pass

func _on_PlayAgainButton_mouse_entered():
	$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/PlayAgainButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_PlayAgainButton_mouse_exited():
	$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/PlayAgainButton/Label.get_font("font").outline_color = Color("#000000")
	pass

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")
	reset_global()
	pass

func _on_MainMenuButton_mouse_entered():
	$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/MainMenuButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_MainMenuButton_mouse_exited():
	$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/MainMenuButton/Label.get_font("font").outline_color = Color("#000000")
	pass

func _on_WorldButton_mouse_entered():
	$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/WorldButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_WorldButton_mouse_exited():
	$CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/WorldButton/Label.get_font("font").outline_color = Color("#000000")
	pass

func _on_WorldButton_pressed():
	get_tree().change_scene("res://Scenes/StartingArea.tscn") #TODO change this
	reset_global()
	print("pressing button")
	pass 
