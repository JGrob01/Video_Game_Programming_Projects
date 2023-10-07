extends Node2D

export var file_path_to_destination := NodePath()

onready var _destination = get_node(file_path_to_destination)
onready var _agent : NavigationAgent2D = $CarTemplate/NavigationAgent2D

var RIGHT = 1
var LEFT = -1


func _ready():
	_agent.set_target_location(_destination.global_position)


func _physics_process(delta):
	if _agent.distance_to_target() <= 10: # because _agent.is_navigation_finished() didn't work when I turned off steering?
		print("Made it")
		return

	var next_location = _agent.get_next_location()
	$"../../RedDot".global_position = next_location
	var direction = $CarTemplate.global_position.direction_to(next_location)
	
#	$CarTemplate.calculate_magnitudes()
	# Updating the global variables which are used in the UI
	
	# Spawn a smoketrail when acceleration is large 
	$CarTemplate.spawn_smoke_trail(delta)
	
	# Creates the tire trails behind the car 
	$CarTemplate.spawn_tire_trail()
	
	$CarTemplate.check_turbo(delta)
	
	$CarTemplate.acceleration = Vector2.ZERO
	
	get_input(next_location)
	
	$CarTemplate.apply_friction()
	$CarTemplate.calculate_steering(delta)
	$CarTemplate.adjust_velocity(delta)


func get_input(next_loc : Vector2):
	var forward_dir = -1 * $CarTemplate.global_position.direction_to($CarTemplate/ParticleSpawnLocation.global_position) # Will drive backwards
	var target_dir = $CarTemplate.global_position.direction_to(next_loc)
	var determinant = forward_dir.x * target_dir.y - forward_dir.y * target_dir.x
	var angle = atan2(determinant, forward_dir.dot(target_dir)) # angle in clockwise direction ranging from 0 - 360 between foraward direction and target dir
	print("Angle : ", angle)
	
	var turn = 0
	if angle > 1 and angle < 179: # gives 1 margin of error (0 - 180)
		print("turn right")
		turn = $CarTemplate.turn_car(RIGHT, turn)
	elif angle > 182 and angle < 359: # gives 1 margin of error (181 - 360)
		print("turn left")
		turn = $CarTemplate.turn_car(LEFT, turn)
	$CarTemplate.calculate_turn(turn)

	var distance_to_target = $CarTemplate.global_position.distance_to(next_loc)
	if distance_to_target > 300:
		print("accelerate")
		$CarTemplate.accelerate_car()
#	elif distance_to_target > 290:
#		print("brake")
#		$CarTemplate.brake_car()




#var _velocity = Vector2.ZERO
#
#onready var _agent : NavigationAgent2D = $NavigationAgent2D
#onready var _destination := get_node(file_path_to_destination)
#
#
#func _ready():
#	_agent.set_target_location(_destination.global_position)
#
#
#func _physics_process(delta : float):
#	# prevents the onbject from moving anymore once it has reached its destination 
#	if _agent.distance_to_target() <= 10: # because _agent.is_navigation_finished() didn't work when I turned off steering?
#		print("Made it")
#		return
#
#	var next_location = _agent.get_next_location()
#	$"../../RedDot".global_position = next_location
#	var direction = global_position.direction_to(next_location)
#
#	var desired_velocity = direction * 100.0
##	var steering = (desired_velocity - _velocity) * delta * 4.0
##	_velocity += steering
#	$Sprite.rotation = _velocity.angle()
#	$CollisionShape2D.rotation = _velocity.angle()
#	_velocity = desired_velocity
#	_velocity = move_and_slide(_velocity)
#
#
