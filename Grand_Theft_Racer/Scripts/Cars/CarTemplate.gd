extends KinematicBody2D

#######################################
# Hannah Moats
# Car template is the contains functions to 
# steer, accelerate, reverse, brake, and 
# use turbo on a car. Also spawns tire trails
# and smoke particles.
# Tutorial for base functionality: http://kidscancode.org/godot_recipes/3.x/2d/car_steering/
#######################################

export var player_car = false # marked true if this is the vehicle that player controls 
var wheel_base = 60 # Distance from front to rear wheel
var steering_angle = 0.5 # Amount that front wheel turns, in degrees

var velocity = Vector2.ZERO
var steer_angle = 0
var acceleration = Vector2.ZERO
export var engine_power = 900 # Forward acceleration force 

# These values calculated the maximum speed the car can reach 
# Visualizing drag and friction : https://www.desmos.com/calculator/e4ayu3xkip
export var friction = -0.2 # We could adjust friction based on the ground type 
export var drag = -0.0005 # Drag becomes dominant at high speeds 

var braking = -450
var max_speed_reverse = 250

var slip_speed = 300 # Speed where traction is reduced 
var traction_fast = 0.05 # High-speed traction 
var traction_slow = 0.4 # Low-speed traction 

# Used when spawning dust behind car
var spawn_time = 0.05 # time between spawning particles
var spawn_timer = spawn_time # tracks the time between particles 
var smoketrail # Stores the smoke particle scene that is used for "dust"

var speed = 0 # Use this for the SPEED-O-METER
var magnitude_acc = 0 

# Tire Burn Makrs
var tire_trail # Tire trail marks scene 
var current_trail # the current trail the car is adding points to

# How Turbo Works : 
# - While speed above 170 and you are not using turbo (turbo applied = false) then turbo is added to the turbo meter 
# - When your turbo reaches max turbo (is filled) the player can press space to use the turbo
# - When the player presses the space, the countdown begins, and the player's speed is 
# 	increased and enusred to not go over the max velocity 
# - when countdown ends, the player's speed is not adjusted, turbo applied = false, reset camera position, remove particles 
var max_turbo_speed = 1500 
var turbo_applied = false 
export var shake_strength = 3 
var current_turbo_meter = 0 
var collected_coins = 0 
export var max_turbo = 20 # The amount of turbo you need in your meter to be able to use it again
export var turbo_time = 5 # time you have the turbo turned on
var turbo_timer = turbo_time # tracks how long the turbo has lasted, when reaches 0, turbo turned off


func _ready():
	$Camera2D.set_active_camera(player_car)
	
	if not player_car:
		# Set to random sprite and colors
		$CustomCar.set_random_car_sprite()
		# Disable damage dector
		$DamageDetector/CollisionShape2D.disabled = true
	else: 
		remove_child($NavigationAgent2D) #disable the navigation 
		# Set car sprite and colors via globals
		$CustomCar.set_player_car_sprite()
		
	# This sets the collider for the car, and the damage detector collider, based on the type of car
	set_car_colliders()
	
	smoketrail = load("res://Scenes/Particles/SmokeTrailParticle.tscn")
	tire_trail = load("res://Scenes/Particles/Trail.tscn")


func _process(delta):
	if turbo_applied:
		$Camera2D.violently_shake_camera_repeatedly(shake_strength)
	
	# Add to turbo meter 
	if speed >= 170 and not turbo_applied:
		current_turbo_meter += delta 
	
	$EnginePlayer.adjust_car_engine_sound(speed, 195)

	# print(str(Engine.get_frames_per_second()))


func calculate_magnitudes():
	# Magnitude of acceleration vector
	magnitude_acc = abs(acceleration.x) + abs(acceleration.y)
	# Magnitude of velocity vector
	speed = get_speed()

func get_speed() -> float:
	return velocity.length() / 6


func check_turbo(delta_time):
	if turbo_applied:
		turbo_timer -= delta_time
		var normal = velocity.normalized()
		var l = velocity.length()
		velocity = normal * min(l * 1.2, max_turbo_speed)
#		$Camera2D.offset = get_camera_offset() # Shaking camera
		# Check if turbo is out
		if turbo_timer <= 0: 
			turn_off_turbo() 


func adjust_velocity(delta_time): 
	velocity += acceleration * delta_time 
	velocity = move_and_slide(velocity) 


# Action Functions : functions called by outside code to move car 
# Turns the car towards a certain direction  
# Pass 1 if turning right, pass -1 if turning left 
func turn_car(direction : int, turn : float ) -> float:
	turn += direction
	return turn 


func calculate_turn(turn : float):
	steer_angle = turn * steering_angle # the car turns by 15 degrees each time


# Applies acceleration 
func accelerate_car():
	acceleration = transform.x * engine_power


# Applies brake 
func brake_car():
	acceleration = transform.x * braking


# Applies turbo to the car if the conditions are valid 
func turbo_car():
	if not turbo_applied and current_turbo_meter > max_turbo:
		turn_on_turbo()


func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force


# Functions that shouldn't need to be called from out of this class ...
func calculate_steering(delta_time : float):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta_time
	front_wheel += velocity.rotated(steer_angle) * delta_time
	var new_heading = (front_wheel - rear_wheel).normalized()
	
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0: 
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()


# Functions that spawn particles and trails
# Spawns smoke when the car's acceleration is greater than 750
# TODO : implement object pooling
func spawn_smoke_trail(delta_time):
	if magnitude_acc > 750 and spawn_timer <= 0:
		spawn_timer = spawn_time # restarting timer
		var trail = smoketrail.instance() 
		trail.position = $ParticleSpawnLocation.global_position
		add_child(trail)
		trail.emitting = true
	else:
		spawn_timer -= delta_time


# Spawn a trail behind the car 
# TODO : implement Object pooling
func spawn_tire_trail():
	if magnitude_acc > 750: 
		if current_trail == null: 
			$TireSquealPlayer.toggle_sound(-1)
			current_trail = tire_trail.instance() 
			add_child(current_trail) 
		current_trail.add_point(global_position) 
	elif magnitude_acc <= 750 and current_trail != null:
		$TireSquealPlayer.toggle_sound(-1) 
		current_trail = null 


func turn_off_turbo():
	$TurboJetPlayer.toggle_sound(0)
	turbo_applied = false
	$Camera2D.offset = Vector2.ZERO # resetting the camera when turbo is off
	$TurboParticlesLeft.emitting = false
	$TurboParticlesRight.emitting = false
	turbo_timer = turbo_time
	current_turbo_meter = 0 


func turn_on_turbo():
	$TurboJetPlayer.toggle_sound(0)
	turbo_applied = true
	$TurboParticlesLeft.emitting = true
	$TurboParticlesRight.emitting = true


# Sets the colliders to the correct positions based on the height of the car sprite
# Asjusts the turbo spawn location and particles spawn location
func set_car_colliders():
	# Set cars collisions shape collider (capsule with height based on texture height, and constant radius of 21)
	var mid_height = $CustomCar.texture.get_height() - $CollisionShape2D.get_shape().radius
	$CollisionShape2D.get_shape().height = 2 * mid_height
	
#	print("Texture Height: ", $CustomCar.texture.get_height())
#	print("Collider Size: ", $CollisionShape2D.get_shape().height, " ", $CollisionShape2D.get_shape().radius)
	
	# Set cars damage detector collider (circle with radius ~23)
	$DamageDetector/CollisionShape2D.position.x = mid_height
	
	# Move particle spawn locations 
	$TurboParticlesLeft.position.x = -($CustomCar.texture.get_height() - 3)
	$TurboParticlesRight.position.x = -($CustomCar.texture.get_height() - 3)
	
	$ParticleSpawnLocation.position.x = -($CustomCar.texture.get_height() + 17)
	
