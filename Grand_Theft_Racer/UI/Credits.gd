extends Control

func _ready():
	$VBoxContainer.set_position(Vector2(0, rect_size.y))
	pass


func _process(delta):
	
	
	if $VBoxContainer.rect_position.y <= -$VBoxContainer.rect_size.y:
		$VBoxContainer.set_position(Vector2(0, rect_size.y))
	else:
		$VBoxContainer.set_position(Vector2(0, $VBoxContainer.rect_position.y - 1))
	pass

func _on_MenuButton_pressed():
	get_tree().change_scene("res://UI/MainMenu.tscn")
	pass
