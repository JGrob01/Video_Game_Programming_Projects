extends KinematicBody2D
# Based on following tutorial : http://kidscancode.org/godot_recipes/3.x/2d/car_steering/

var wheel_base = 60 # Distance from front to rear wheel
var steering_angle = 0.5 # Amount that front wheel turns, in degrees

var velocity = Vector2.ZERO
var steer_angle 
var acceleration = Vector2.ZERO
var engine_power = 900 # Forward acceleration force 

# These values calculated the maximum speed the car can reach 
# Visualizing drag and friction : https://www.desmos.com/calculator/e4ayu3xkip
var friction = -0.2 # We could adjust friction based on the ground type 
var drag = -0.0005 # Drag becomes dominant at high speeds 

var braking = -450
var max_speed_reverse = 250

var slip_speed = 300 # Speed where traction is reduced 
var traction_fast = 0.05 # High-speed traction 
var traction_slow = 0.4 # Low-speed traction 

# Used when spawning dust behind car
var spawn_time = 0.05 # time between spawning particles
var spawn_timer = spawn_time # tracks the time between particles 
var smoketrail # Stores the smoke particle scene that is used for "dust"

# Zooming Camera In and Out
var camera_zoomed_out = false
var t = 0 # Used when zooming out camera out on vehicle 

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
export var max_turbo = 20 # The amount of turbo you need in your meter to be able to use it again
export var turbo_time = 5 # time you have the turbo turned on
var turbo_timer = turbo_time # tracks how long the turbo has lasted, when reaches 0, turbo turned off


func _ready():
	smoketrail = load("res://Scenes/Particles/SmokeTrailParticle.tscn")
	tire_trail = load("res://Scenes/Particles/Trail.tscn")

func _process(delta):
	if turbo_applied:
		$Camera2D.offset = get_camera_offset()
	
	# Add to turbo meter 
	if speed >= 170 and not turbo_applied:
		current_turbo_meter += delta 
		print(current_turbo_meter)

	#print(str(Engine.get_frames_per_second()))
	# zoom_camera(delta)


func _physics_process(delta):
	# Magnitude of acceleration vector
	magnitude_acc = abs(acceleration.x) + abs(acceleration.y)
	# Magnitude of velocity vector
	speed = velocity.length() / 6
	
	# Spawn a smoketrail when acceleration is large 
	spawn_smoke_trail(delta)
	
	# Creates the tire trails behind the car 
	spawn_tire_trail()
	
	# Zoom in and out camera based on speed 
	zoom_camera(delta)
	
	if turbo_applied:
		turbo_timer -= delta
		var normal = velocity.normalized()
		var l = velocity.length()
		velocity = normal * min(l * 1.2, max_turbo_speed)
		$Camera2D.offset = get_camera_offset() # Shaking camera
		# Check if turbo is out
		if turbo_timer <= 0:
			turn_off_turbo()
	
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity) 


func get_input():
	var turn = 0 
	if Input.is_action_pressed("steer_right"):
		turn += 1
	if Input.is_action_pressed("steer_left"):
		turn -= 1
	steer_angle = turn * steering_angle # the car turns by 15 degrees each time
	
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
	if Input.is_action_just_pressed("turbo") and not turbo_applied and current_turbo_meter > max_turbo:
		turn_on_turbo()


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


func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force


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
			current_trail = tire_trail.instance() 
			add_child(current_trail) 
		current_trail.add_point(global_position) 
	elif magnitude_acc <= 750: 
		current_trail = null 


# When car goes over speed 100, the camera zooms out, zooms in when the car car slows below 100
func zoom_camera(delta_time):
	if speed > 120 and not camera_zoomed_out:
		if $Camera2D.zoom.x >= 1.15:
			camera_zoomed_out = true
			t = 0
		else:
			t += delta_time * 0.1
			$Camera2D.zoom = $Camera2D.zoom.linear_interpolate(Vector2(1.2,1.2), t)
#		$Camera2D.zoom = Vector2(1.5, 1.5)
#		camera_zoomed_out = true
	elif speed <= 120 and camera_zoomed_out:
		if $Camera2D.zoom.x <= 1.05:
			camera_zoomed_out = false
			t = 0
		else:
			t += delta_time * 0.1
			$Camera2D.zoom = $Camera2D.zoom.linear_interpolate(Vector2(1,1), t)
#		$Camera2D.zoom = Vector2(1, 1)
#		camera_zoomed_out = false


func turn_off_turbo():
	turbo_applied = false
	$Camera2D.offset = Vector2.ZERO # resetting the camera when turbo is off
	$TurboParticlesLeft.emitting = false
	$TurboParticlesRight.emitting = false
	turbo_timer = turbo_time
	current_turbo_meter = 0 


func turn_on_turbo():
	turbo_applied = true
	$TurboParticlesLeft.emitting = true
	$TurboParticlesRight.emitting = true


func get_camera_offset() -> Vector2:
	return Vector2(
		rand_range(-shake_strength, shake_strength),
		rand_range(-shake_strength, shake_strength)
	)
