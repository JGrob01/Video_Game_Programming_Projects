extends Control

var RANK_SPRITES = [
	null,
	load("res://Assets/Placements/1st.png"),
	load("res://Assets/Placements/2nd.png"),
	load("res://Assets/Placements/3rd.png"),
	load("res://Assets/Placements/4th.png"),
	load("res://Assets/Placements/5th.png"),
	load("res://Assets/Placements/6th.png")
]

func _ready():
	$TimerLabel.visible = GlobalVariables.time_trial
	MusicPlayer.play()
	pass

func _process(delta):
	$SpeedLabel.text = str(round(GlobalVariables.speed)) + "mph"
	set_ranking(GlobalVariables.ranking)
	
	if GlobalVariables.time_trial:
		$TimerLabel.text = format_time(GlobalVariables.current_time)
	
	$Turbometer.max_value = GlobalVariables.MAX_TURBO_METER
	$Turbometer.value = min(GlobalVariables.MAX_TURBO_METER, GlobalVariables.current_turbo_meter)
	$HealthMeter.max_value = GlobalVariables.MAX_HEALTH_METER
	$HealthMeter.value = min(GlobalVariables.MAX_HEALTH_METER, GlobalVariables.health)
	
	if (!MusicPlayer.paused && MusicPlayer.current_track > -1):
		$RadioLabel.text = "Now Playing: " + MusicPlayer.current_track_name
	
	$RadioLabel.visible = !MusicPlayer.paused
	pass
	
var time = 0

func _physics_process(delta):
	$DamageTextureRect.visible = GlobalVariables.take_damage
	
	if $DamageTextureRect.visible:
		animate_damage_bar($DamageTextureRect.visible, time)
		time += 1
	
		if time == 120:
			time = 0
			GlobalVariables.take_damage = false
	
	if GlobalVariables.health <= 0 || GlobalVariables.race_over:
		GlobalVariables.previous_scene = get_tree().current_scene.filename # Saves the scene you are in for the playagain stuff
		if GlobalVariables.health <= 0:
			GlobalVariables.dead = true
		GlobalVariables.race_over = true
		get_tree().change_scene("res://UI/GameOverMenu.tscn")
	pass

func set_ranking(rank):
	if rank < 1:
		rank = 1
	elif rank > 6:
		rank = 6
	
	$RankingTextureRect.texture = RANK_SPRITES[rank]
	pass

func format_time(ticks):
	var seconds = ticks / 60
	var minutes = seconds / 60
	var hours = int(minutes / 60)
	
	return str(hours) + ":" + str(int(minutes) % 60) + ":" + str(fmod(seconds, 60))

func animate_damage_bar(visible, time):
	if visible:
		$DamageTextureRect.modulate.a = ((cos(time / 5) + 1) / 2)
		$SpeedLabel.text = str(time)
	pass

func take_damage():
	$DamageTextureRect.visible = true
