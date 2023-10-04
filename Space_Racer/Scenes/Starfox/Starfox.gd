# Author: Hunter Kindlin
# Implements spaceship movement
extends KinematicBody

export var TURN_RATE = 1
export var PITCH_RATE = 1
export var AUTOLEVEL_RATE = 2.0
export var ACCELERATION = 30.0

# Current speed
var throttle_delta = 30
var forward_speed = 0

var velocity = Vector3.ZERO
var turn_input = 0
var pitch_input = 0

var lights = []
var particles = []
var flame_mesh = []

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("Players")

	# Setup thruster effect arrays
	lights.append_array([
		get_node("Hull/ThrusterEffects/Left/L Light"),
		get_node("Hull/ThrusterEffects/Center/C Light"),
		get_node("Hull/ThrusterEffects/Right/R Light")
	])
	particles.append_array([
		get_node("Hull/ThrusterEffects/Left/Particles"),
		get_node("Hull/ThrusterEffects/Center/Particles2"),
		get_node("Hull/ThrusterEffects/Right/Particles3"),
	])
	flame_mesh.append_array([
		get_node("Hull/ThrusterEffects/Left/Flame2"),
		get_node("Hull/ThrusterEffects/Center/Flame"),
		get_node("Hull/ThrusterEffects/Right/Flame3"),
	])
	
	# Init all thruster effects to off states
	for light in lights:
		light.visible = false
	for mesh in flame_mesh:
		mesh.visible = false
	for emitter in particles:
		emitter.emitting = false

func _physics_process(delta):
	thruster_effects()
	get_input(delta)
	
	# Rotate the transform based on the input values
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * PITCH_RATE * delta)
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input * TURN_RATE * delta)
	# If on the ground, don't roll the mesh
	if forward_speed < GlobalVariables.MIN_FLIGHT_SPEED/2:
		$Hull.rotation.z = 0
	else:
		# Roll the mesh
		$Hull.rotation.z = lerp($Hull.rotation.z, turn_input, AUTOLEVEL_RATE * delta)
	# Accelerate/decelerate
	var target_speed = GlobalVariables.MIN_FLIGHT_SPEED if GlobalVariables.is_slowed() else GlobalVariables.target_speed
	forward_speed = lerp(forward_speed, target_speed, ACCELERATION * delta)
	# Movement is always forward
	velocity = -transform.basis.z * forward_speed

	velocity = move_and_slide(velocity, Vector3.UP)
	
	# Update global variables
	GlobalVariables.player_position = transform.origin
	GlobalVariables.player_rotation = $Hull.rotation
	
	if GlobalVariables.slow_time > 0:
		GlobalVariables.slow_time -= 1
	
	print(forward_speed)

func get_input(delta):
	# Throttle input
	if Input.is_action_pressed("throttle_up") and GlobalVariables.energy > 0:
		GlobalVariables.target_speed = min(forward_speed + throttle_delta * delta, GlobalVariables.MAX_FLIGHT_SPEED)
		GlobalVariables.energy -= 1
	if Input.is_action_pressed("throttle_down"):
		# Stop player from soft-locking and not being able to move
		if GlobalVariables.energy == 0 and GlobalVariables.target_speed < GlobalVariables.MIN_FLIGHT_SPEED:
			GlobalVariables.target_speed = GlobalVariables.MIN_FLIGHT_SPEED
		else:
			GlobalVariables.target_speed = max(forward_speed - throttle_delta * delta, GlobalVariables.MIN_FLIGHT_SPEED)
			GlobalVariables.energy -= 1
	# Roll (and yaw) input
	turn_input = 0
	if forward_speed > 0.5:
		turn_input -= Input.get_action_strength("roll_right")
		turn_input += Input.get_action_strength("roll_left")
	# Pitch input
	pitch_input = 0
	if forward_speed > 0.5:
		pitch_input -= Input.get_action_strength("pitch_down")
		pitch_input += Input.get_action_strength("pitch_up")

# Make thrusters to on/off or emit particles when above certain speeds
# Particle speed is tied to movement speed
func thruster_effects():
	if forward_speed > 1:
		for light in lights:
			light.visible = true
		for mesh in flame_mesh:
			mesh.visible = true
		$Engine.play()
	else: 
		for light in lights:
			light.visible = false
		for mesh in flame_mesh:
			mesh.visible = false
		$Engine.stop()
			
	if forward_speed >= GlobalVariables.MIN_FLIGHT_SPEED:
		for emitter in particles:
			emitter.emitting = true
			emitter.speed_scale = (forward_speed/100)+2	
	else:
		for emitter in particles:
			emitter.emitting = false
			emitter.speed_scale = 1

#Author: John Grobaker
func _on_Area_body_entered(body):
	if GlobalVariables.can_take_damage and body.name != "Parts":
		$Damage.play()
		GlobalVariables.damage -= 10
