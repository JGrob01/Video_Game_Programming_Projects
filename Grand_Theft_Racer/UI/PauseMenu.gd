extends Control

func _process(delta):
	get_input()
	pass

func get_input():	
	if Input.is_action_just_released("Escape"):
		visible = !visible
		GlobalVariables.paused = !GlobalVariables.paused
	pass

func _on_ContinueButton_pressed():
	visible = false
	GlobalVariables.paused = false
	pass

func _on_SaveButton_pressed():
	GlobalVariables.save_to_json()
	MusicPlayer.pause()
	get_tree().change_scene("res://UI/MainMenu.tscn")
	pass

func _on_ContinueButton_mouse_entered():
	$CenterContainer/VBoxContainer/ContinueButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_SaveButton_mouse_entered():
	$CenterContainer/VBoxContainer/SaveButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_ContinueButton_mouse_exited():
	$CenterContainer/VBoxContainer/ContinueButton/Label.get_font("font").outline_color = Color("#000000")
	pass

func _on_SaveButton_mouse_exited():
	$CenterContainer/VBoxContainer/SaveButton/Label.get_font("font").outline_color = Color("#000000")
	pass
