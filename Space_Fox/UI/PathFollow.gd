# Author: Hunter Kindlin

extends PathFollow

var move_speed = .5

onready var camera = get_node("Camera")

#Positions to look at
onready var SHIP = get_parent().get_parent().get_node("Starfox/Hull").global_transform.origin
onready var PLANET1 = get_parent().get_parent().get_node("Planets/Planet").global_transform.origin
onready var PLANET2 = get_parent().get_parent().get_node("Planets/Planet3").global_transform.origin
onready var PLANET3 = get_parent().get_parent().get_node("Planets/Planet5").global_transform.origin


# Called when the node enters the scene tree for the first time.
func _ready():
	camera.current = true
	camera.look_at(SHIP, Vector3.UP)
	pass # Replace with function body.

func _physics_process(delta):
	# Look at ship
	if get_offset() < 20:
		move_speed += .5*delta
		camera.look_at(SHIP, Vector3.UP)
	# Look at planet 1, speed up
	elif get_offset() >= 18 and get_offset() <= 350:
		if get_offset() < 250:
			move_speed += 7*delta
		camera.look_at(PLANET1, Vector3.UP)
	# Look at next planet
	elif get_offset() > 350 and get_offset() <= 1300:
		camera.look_at(PLANET2, Vector3.UP)
	# Look at planet 3
	elif get_offset() > 1300 and get_offset() <= 4000:
		camera.look_at(PLANET3, Vector3.UP)
	
	set_offset(get_offset() + move_speed * delta)
