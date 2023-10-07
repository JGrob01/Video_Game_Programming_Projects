extends Control

func _ready():
	GlobalVariables.read_from_json()
	MusicPlayer.pause()
	pass

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/StartingArea.tscn")
	pass

func _on_HelpButton_pressed():
	get_tree().change_scene("res://UI/HelpMenu.tscn")
	pass

func _on_CreditsButton_pressed():
	get_tree().change_scene("res://UI/Credits.tscn")
	pass
	
func _on_QuitButton_pressed():
	get_tree().quit()
	pass

func _on_PlayButton_mouse_entered():
	$CenterContainer/VBoxContainer/PlayButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_HelpButton_mouse_entered():
	$CenterContainer/VBoxContainer/HelpButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_CreditsButton_mouse_entered():
	$CenterContainer/VBoxContainer/CreditsButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_QuitButton_mouse_entered():
	$CenterContainer/VBoxContainer/QuitButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_PlayButton_mouse_exited():
	$CenterContainer/VBoxContainer/PlayButton/Label.get_font("font").outline_color = Color("#000000")
	pass

func _on_HelpButton_mouse_exited():
	$CenterContainer/VBoxContainer/HelpButton/Label.get_font("font").outline_color = Color("#000000")
	pass

func _on_CreditsButton_mouse_exited():
	$CenterContainer/VBoxContainer/CreditsButton/Label.get_font("font").outline_color = Color("#000000")
	pass

func _on_QuitButton_mouse_exited():
	$CenterContainer/VBoxContainer/QuitButton/Label.get_font("font").outline_color = Color("#000000")
	pass

func _on_CustomizeButton_pressed():
	get_tree().change_scene("res://UI/CustomizeMenu.tscn")
	pass

func _on_CustomizeButton_mouse_entered():
	$CenterContainer/VBoxContainer/CustomizeButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_CustomizeButton_mouse_exited():
	$CenterContainer/VBoxContainer/CustomizeButton/Label.get_font("font").outline_color = Color("#000000")
	pass
