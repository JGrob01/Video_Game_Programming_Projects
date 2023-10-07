extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var red_dot_file := NodePath()
onready var red_dot = get_node(red_dot_file)
export var object_file := NodePath()
onready var car = get_node(object_file)


# Called when the node enters the scene tree for the first time.
func _ready():
#	print($Path2D.curve.get_point_count())
#	print($Path2D.curve.get_point_position(5))
#	print($Path2D.curve.get_baked_points().size())
	print($Path2D.curve.get_baked_length()) # returns the length of the line


func _process(delta):
	if Input.is_action_just_pressed("steer_left"):
		set_point($Path2D.curve.get_closest_point(car.global_position))
		
	if Input.is_action_just_pressed("steer_right"):
		print($Path2D.curve.get_closest_offset($Path2D.curve.get_closest_point(car.global_position))) #returns how far along the line you are


func set_point(target : Vector2): 
	red_dot.global_position = target 
