extends Node

func _ready():
	get_node("World/Path/PathFollow/Camera").current = true
	get_node("World/Starfox/Camera").current = false
	
	$Control/CenterContainer/VBoxContainer/PlayButton.connect("pressed", self, "play_button_pressed")
	$Control/CenterContainer/VBoxContainer/QuitButton.connect("pressed", self, "quit_button_pressed")
	
	AudioPlayer.play_music()
	
	pass

func play_button_pressed():
	get_tree().change_scene("res://MainGameScene.tscn")
	pass

func quit_button_pressed():
	get_tree().quit()


func _on_QuitButton_mouse_entered():
	$Control/CenterContainer/VBoxContainer/QuitButton.modulate = "99edfe"


func _on_QuitButton_mouse_exited():
	$Control/CenterContainer/VBoxContainer/QuitButton.modulate = "ffffff"


func _on_PlayButton_mouse_entered():
	$Control/CenterContainer/VBoxContainer/PlayButton.modulate = "99edfe"


func _on_PlayButton_mouse_exited():
	$Control/CenterContainer/VBoxContainer/PlayButton.modulate = "ffffff"
