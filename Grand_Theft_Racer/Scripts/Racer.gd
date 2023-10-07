###################################################
# Stores data on each racer during a race. data includes
# the total race time, the time since the last check point, 
# the number of laps, and a reference to the car node it
# is following. Also the rank of the racer. 
# 
# devin foster and Hannah M
##################################################
class_name Racer

var laps : int = 0
var time_since_last_checkpoint : float = 0
var total_race_time : float = 0 # Time car takes to complete race
var racer
var is_player : bool # tracks if the racer is the player car or not
var rank : float = 1 # ranks span from 1st to 6th

# Devin
func _init(racer_node : Object, player : bool):
	racer = racer_node
	is_player = player
#	print("is_player : ", is_player)
	

# Allows the racer to follow the point
func start_racer():
	if (not is_player):
		racer.stop_following = false


# Devin and hannah 
func increment_lap(max_laps : int):
	laps += 1
#	print("laps : ", laps)
	if (is_player and laps > max_laps):
		GlobalVariables.ranking = rank
		GlobalVariables.race_over = true
#		print("Race Over")
	elif (not is_player and laps > max_laps):
		print("End race")
		racer.stop_following = true


# Hannah
func set_rank(ranking : int):
	if (is_player):
		GlobalVariables.ranking = ranking
	rank = ranking


# Hannah 
# Sorts the racer based on its ranking which is a value meant to represent 
# how many laps they are into the race, how far into the race they are, and the 
# time it took them to get there. 
static func sort_position(racer_1, racer_2):
	if racer_1.rank < racer_2.rank:
		return true
	return false


