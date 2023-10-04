# Author: Hunter Kindlin
# Purpose: Control movement of plane 

extends KinematicBody

# Import globals
var GLOBALS = GlobalVariables
var FRICTION = GLOBALS.FRICTION
var ACCELERATION = GLOBALS.ACCELERATION
var TERMINAL_VELOCITY = GLOBALS.TERMINAL_VELOCITY

# Plane specific characteristics
export var PITCH_ACCELERATION = 10 * 60
export var YAW_ACCELERATION = 10 * 60

# Current position/speed
var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Plane takes off from start position automatically.
# Sets forward velocity.
func take_off():
	pass
