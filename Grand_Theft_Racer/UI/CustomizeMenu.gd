extends TextureRect

func _ready():
	$MainColorButton.color = GlobalVariables.main_color
	$AccentColorButton.color = GlobalVariables.accent_color
	$SpriteBorder/SkinSprite.texture = GlobalVariables.car_sprite
	$SpriteBorder/SkinSprite.material.set_shader_param("color", $MainColorButton.color)
	$SpriteBorder/SkinSprite.material.set_shader_param("accent_color", $AccentColorButton.color)
	pass

func _on_SaveButton_pressed():
	GlobalVariables.main_color = $MainColorButton.color
	GlobalVariables.accent_color = $AccentColorButton.color
	GlobalVariables.save_to_json()
	get_tree().change_scene("res://UI/MainMenu.tscn")
	pass

func _on_Cancel_Button_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")
	pass
	
func _on_LeftTextureButton_pressed():
	GlobalVariables.previous_car_sprite()
	$SpriteBorder/SkinSprite.texture = GlobalVariables.car_sprite
	pass

func _on_RightTextureButton_pressed():
	GlobalVariables.next_car_sprite()
	$SpriteBorder/SkinSprite.texture = GlobalVariables.car_sprite
	pass

func _on_MainColorButton_color_changed(color):
	$SpriteBorder/SkinSprite.material.set_shader_param("color", $MainColorButton.color)
	pass

func _on_AccentColorButton_color_changed(color):
	$SpriteBorder/SkinSprite.material.set_shader_param("accent_color", $AccentColorButton.color)
	pass

func _on_LeftTextureButton_mouse_entered():
	pass

func _on_LeftTextureButton_mouse_exited():
	pass

func _on_RightTextureButton_mouse_entered():
	pass

func _on_RightTextureButton_mouse_exited():
	pass
