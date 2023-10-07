extends Node

var ALL_RADIO_TRACKS = [
	load("res://Assets/Music/Radio/action-protection-118722.mp3"),
	load("res://Assets/Music/Radio/afterburner.mp3"),
	load("res://Assets/Music/Radio/a-sharp-turn-113216.mp3"),
	load("res://Assets/Music/Radio/autobahn-99109.mp3"),
	load("res://Assets/Music/Radio/dystopian-city-8683.mp3"),
	load("res://Assets/Music/Radio/hard_driving_blues.mp3"),
	load("res://Assets/Music/Radio/mactonite_-_Warp_Drive_1.mp3"),
	load("res://Assets/Music/Radio/wild-west-126293.mp3"),
	load("res://Assets/Music/Radio/Zenboy1955_-_Random_Shots_(Remix).mp3"),
	load("res://Assets/Music/Radio/Zenboy1955_-_The_Bliss_of_Vertigo_(Whirling_Dervish_Edition)_1.mp3")
]
var ALL_TRACK_NAMES = [
	"Action Protection",
	"After Burner",
	"A Sharp Turn",
	"Autobahn",
	"Dystopian City",
	"Hard Driving Blues",
	"Warp Drive",
	"Wild West",
	"Random Shots",
	"The Bliss of Vertigo"
]

var track_dict = { 0: "Action Protection", 1: "After Burner", 2: "A Sharp Turn", 3: "Autobahn", 4:"Dystopian City", 5: "Hard Driving Blues", 
6: "Warp Drive", 7: "Wild West", 8: "Random Shots", 9: "The Bliss of Vertigo"} 


var unlocked_tracks = []
var unlocked_track_names = []
var current_track = -1
var current_track_name 
var paused = true

func _process(delta):
	if (Input.is_action_just_pressed("NextTrack")):
		select_next_track()
	pass

func select_next_track():
	if len(unlocked_tracks) > 0:
		var random = RandomNumberGenerator.new()
		
		random.randomize()
		current_track = random.randi_range(0, len(unlocked_tracks) - 1)
		$AudioStreamPlayer.stream = unlocked_tracks[current_track]
		current_track_name = unlocked_track_names[current_track] 
		play()
	pass

func add_new_track(index):
	if !(ALL_RADIO_TRACKS[index] in unlocked_tracks):
		unlocked_tracks.append(ALL_RADIO_TRACKS[index])
		unlocked_track_names.append(track_dict[index])
	pass

func play():
	paused = false
	$AudioStreamPlayer.play()
	pass

func pause():
	paused = true
	$AudioStreamPlayer.stop()
	pass

func _on_AudioStreamPlayer_finished():
	if paused == false:
		select_next_track()
	pass
