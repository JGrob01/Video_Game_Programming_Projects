extends Node2D
##########################################
# Hannah Moats
# Attached to node which has the CarTemplate
# as a child. Allows a player to control a car via 
# keyboard input.
##########################################

var RIGHT = 1
var LEFT = -1

func _ready():
	GlobalVariables.read_from_json()
	$CarTemplate.current_turbo_meter = GlobalVariables.current_turbo_meter
	$CarTemplate.position = GlobalVariables.player_location
	$CarTemplate.rotation = GlobalVariables.player_rotation
	$CarTemplate.collected_coins = GlobalVariables.coins
	
	pass

func _physics_process(delta):
	$CarTemplate.calculate_magnitudes()
	# Updating the global variables which are used in the UI
	# Done here, since the CarTemplate.gd is used across all cars, and we don't want their values (only this car)
	GlobalVariables.speed = $CarTemplate.speed
#	print(GlobalVariables.speed)
	GlobalVariables.current_turbo_meter = $CarTemplate.current_turbo_meter
	GlobalVariables.player_location = $CarTemplate.position
	GlobalVariables.player_rotation = $CarTemplate.rotation
	
	# Spawn a smoketrail when acceleration is large 
	$CarTemplate.spawn_smoke_trail(delta)
	
	# Creates the tire trails behind the car 
	$CarTemplate.spawn_tire_trail()
	
	# Zoom in and out camera based on speed 
#	$Camera2D.zoom_camera(delta) # it ain't working :(
	
	$CarTemplate.check_turbo(delta)
	
	$CarTemplate.acceleration = Vector2.ZERO
	
	get_input()
	
	$CarTemplate.apply_friction()
	$CarTemplate.calculate_steering(delta)
	$CarTemplate.adjust_velocity(delta)


func get_input():
	var turn = 0
	if Input.is_action_pressed("steer_right"):
		turn = $CarTemplate.turn_car(RIGHT, turn)
	elif Input.is_action_pressed("steer_left"):
		turn = $CarTemplate.turn_car(LEFT, turn)
	$CarTemplate.calculate_turn(turn)

	if Input.is_action_pressed("accelerate"):
		$CarTemplate.accelerate_car()
	if Input.is_action_pressed("brake"):
		$CarTemplate.brake_car()
	if Input.is_action_just_pressed("turbo"):
		$CarTemplate.turbo_car()


