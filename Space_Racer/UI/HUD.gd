extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_compass()
	rotate_horizon()
	update_meter_bars()
	update_checkpoint_counter()
	check_player_bars()
	pass

func rotate_compass():
	if GlobalVariables.current_checkpoint < len(GlobalVariables.checkpoints):
		var checkpoint = GlobalVariables.checkpoints[GlobalVariables.current_checkpoint] 
		var num = float(GlobalVariables.player_position.z - checkpoint.z)
		var den = max(GlobalVariables.player_position.x - checkpoint.x, 0.000000000001)
		$CenterContainer/CompassBar.region_rect.position.x = (atan2(num, den) - GlobalVariables.player_rotation.y) * 180 / PI -90 - 39.5
	else: pass

func rotate_horizon():
	$CenterContainer/CompassBar.rotation_degrees = -GlobalVariables.player_rotation.x
	pass;
	
func update_meter_bars():
	$PowerMeter/PowerMeterFill.scale.x = min(1, float(GlobalVariables.energy) / GlobalVariables.MAX_ENERGY)
	$DamageMeter/DamageMeterFill.scale.x = min(1, float(GlobalVariables.damage) / GlobalVariables.MAX_DAMAGE)
	pass
	
func update_checkpoint_counter():
	$CheckpointCounterLabel.text = str(GlobalVariables.current_checkpoint) + " Checkpoints\n" + str(GlobalVariables.star_count) + " Stars"
	pass

func check_player_bars():
	if GlobalVariables.damage == 0:
		get_tree().change_scene("res://UI/End Screen.tscn")
