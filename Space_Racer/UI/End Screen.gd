extends Node

func _ready():
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ReplayButton.connect("pressed", self, "replay_button_pressed")
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/QuitButton.connect("pressed", self, "quit_button_pressed")
	
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ReplayButton.connect("mouse_entered", self, "replay_glow_on")
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ReplayButton.connect("mouse_exited", self, "replay_glow_off")
	
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/QuitButton.connect("mouse_entered", self, "quit_glow_on")
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/QuitButton.connect("mouse_exited", self, "quit_glow_off")
	pass

func replay_button_pressed():
	get_tree().change_scene("res://MainGameScene.tscn")
	GlobalVariables.energy = GlobalVariables.MAX_ENERGY
	GlobalVariables.damage = GlobalVariables.MAX_DAMAGE
	GlobalVariables.star_count = 0
	GlobalVariables.current_checkpoint = 0
	pass

func quit_button_pressed():
	get_tree().quit()
	pass

func quit_glow_on():
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/QuitButton.modulate = "99edfe"


func quit_glow_off():
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/QuitButton.modulate = "ffffff"


func replay_glow_on():
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ReplayButton.modulate = "99edfe"


func replay_glow_off():
	$Control/CenterContainer/VBoxContainer/CenterContainer/VBoxContainer/ReplayButton.modulate = "ffffff"
