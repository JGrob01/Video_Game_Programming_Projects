extends Node

var background_music = load("res://Assets/Audio Effects/Music/track (8).ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_music():
	$Music.stream = background_music
	$Music.play()
