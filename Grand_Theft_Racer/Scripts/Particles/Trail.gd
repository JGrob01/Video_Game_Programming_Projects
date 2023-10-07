extends Line2D
#############################################
# Trail 
# Hannah Moats
#
# Creates the smoke trail effect from behind 
# the cars, applied when speeding up and 
# going around cars. 
#############################################
# Inspired by these tutorials : https://www.youtube.com/watch?v=bqyDm0MmGqg&list=PLcig_EqHq40OqIGvJk0hz83WjPBsuFjIH&index=30
# https://www.youtube.com/watch?v=s5DwZZ0fZDg&t=579s

#export var wildness = 0
export var min_spawn_distance = 5.0 # distance between points 
#var gravity = Vector2.ZERO # I don't want gravity, but it could be an option
var tick_speed : float = 0.1 # Time between points are spawned
var tick : float = 0.0
var point_age = [0.0]
var max_age = 8
#var wild_speed = 0.0


func _ready():
	set_as_toplevel(true) # this way, the trail follows the object correctly 
	clear_points()


func _process(delta):
	if tick > tick_speed:
		tick = 0
		for p in range(get_point_count()):
			point_age[p] += delta + tick_speed
	else: 
		tick += delta 
	
# 	Remove old points
	if point_age[0] > max_age:
		remove_point(0)
		point_age.pop_front()
		if len(point_age) <= 0:
			point_age.append(0.0) # since point_age needs one value

# 	Remove old trail
	if get_point_count() <= 0:
		queue_free() 


# Add point to the trail 
func add_point(point_pos : Vector2, at_pos = -1):
	# Spreads out spawning of points 
	if get_point_count() > 0 and point_pos.distance_to( points[get_point_count()-1] ) < min_spawn_distance:
		return 
	
	point_age.append(0.0)
	.add_point(point_pos, at_pos)
