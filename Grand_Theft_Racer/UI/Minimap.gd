extends TextureRect

func _ready():
	$Cars/PlayerMarker.material.set_shader_param("color", GlobalVariables.main_color)
	$Cars/PlayerMarker.material.set_shader_param("accent_color", GlobalVariables.accent_color)
	pass

func _process(delta):
	$Cars/PlayerMarker.rect_position = Vector2(
		GlobalVariables.player_location.x * 0.0873953 + 200,
		GlobalVariables.player_location.y * 0.0877832 + 66
	)
	pass
