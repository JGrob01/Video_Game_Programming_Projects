extends Node2D
######################################
# Devin Foster
# AI car follows a point given to it. 
# Implements the Navigation nodes which 
# help it navigate obstacles to a certain
# location.
# 
# Used as reference: 
# https://www.youtube.com/watch?v=xuCtxIcfboM 
#####################################

export var file_path_to_destination := NodePath()
export var is_race_car = true
export var is_cop_car = false

onready var _destination = get_node(file_path_to_destination)
onready var _agent : NavigationAgent2D = $CarTemplate/NavigationAgent2D


var RIGHT = 1
var LEFT = -1

var stop_following = true # will toggle on and off when you want the racers to begin following target


func _ready():
	# Assign the final destination point that you are tyring to be reached
	_agent.set_target_location(_destination.global_position)
	pass


func _physics_process(delta):	
	if _agent.distance_to_target() <= 50: 
#		print("You made it!") 
		if is_cop_car:
			pass
		elif is_race_car:
			cross_finish_line()
		else:
			return
	#$CarTemplate.calculate_magnitudes() #updating these adds sounds and tire trails
	
	# Spawn a smoketrail when acceleration is large 
	$CarTemplate.spawn_smoke_trail(delta)
	
	# Creates the tire trails behind the car 
	$CarTemplate.spawn_tire_trail()
	
	$CarTemplate.check_turbo(delta)
	
	$CarTemplate.acceleration = Vector2.ZERO
	
	var dest = _agent.get_next_location()
#	$"../../RedDot".global_position = dest # visually display next location
#	var dest = _destination.global_position
	ai_driver(delta, dest)
	
	$CarTemplate.apply_friction()
	$CarTemplate.calculate_steering(delta)
	$CarTemplate.adjust_velocity(delta)


func ai_driver(delta_time : float, dest : Vector2):
	if stop_following:
		return
	var forward_dir = $CarTemplate.transform.x
	var dir_to_move_pos = (dest - $CarTemplate.global_position).normalized()
	var distance_to_dest = $CarTemplate.global_position.distance_to(dest)
	var reached_target_dist = 100 # minimum distance the car must be to the dest for it to be at target
	
	var accelerate = 0
	var turn = 0
	
	if distance_to_dest > reached_target_dist:
		# Still have not reached target
		is_point_behind_car(forward_dir, dir_to_move_pos)
	
		if (not is_point_behind_car(forward_dir, dir_to_move_pos)): #point in front of car
			accelerate = 1
			
			var stopping_distance = 200 # 350
			var stopping_speed = 70 # 25
			if distance_to_dest < stopping_distance and $CarTemplate.get_speed() > stopping_speed:
				accelerate = -1
		else:
			var reverse_dist = 300
			if  (distance_to_dest > reverse_dist):
				# Too far to reverse
				accelerate = 1
			else:
				# Not too far to reverse
				accelerate = -1
		
		var angle_to_dir = forward_dir.angle_to(dir_to_move_pos)
		if (angle_to_dir > 0):
			turn += $CarTemplate.turn_car(RIGHT, turn)
		else:
			turn += $CarTemplate.turn_car(LEFT, turn)
	else:
		# have reached target
		accelerate = 0
		turn = 0
		
	move_car(turn, accelerate)


func is_point_behind_car(forward_dir : Vector2, dir_to_move_pos : Vector2) -> bool:
#	print(forward_dir)
	var dot = forward_dir.dot(dir_to_move_pos)
	if dot > 0:
#		print("In Front")
		return false
	else:
#		print("Behind")
		return true


func move_car(turn : float, acc : float):
	if acc > 0:
		$CarTemplate.accelerate_car()
	if acc < 0:
		$CarTemplate.brake_car()
	$CarTemplate.calculate_turn(turn)


func cross_finish_line():
	pass
