extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var racer_canvas = $PlayerCar/CanvasLayer/Control
# Called when the node enters the scene tree for the first time.


func _ready():
	racer_canvas.visible = false 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
