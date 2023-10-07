extends Control

func _ready():
	$CarTemplate/CustomCar.material.set_shader_param("color", GlobalVariables.main_color)
	$CarTemplate/CustomCar.material.set_shader_param("accent_color", GlobalVariables.accent_color)
	pass

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")
	pass

func _on_MainMenuButton_mouse_entered():
	$MainMenuButton/Label.get_font("font").outline_color = Color("#505030")
	pass

func _on_MainMenuButton_mouse_exited():
	$MainMenuButton/Label.get_font("font").outline_color = Color("#000000")
	pass
