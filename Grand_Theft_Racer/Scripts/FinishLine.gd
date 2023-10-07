extends Node2D
#############################################
# Acts as the race manager.Manages starting race, 
# ending race, and storing all the racers on the track. 
# Also handles during race things, like rankings/placements. 
# Hannah moats
#############################################


# When a car passes the finish line that has not passed it recenlty then add a lap for their name
export(Array, NodePath) var racer_nodes

var racers = [] # holds Racer class
export (Array, NodePath) var ranks_imgs_paths
var rank_imgs = []

export var checkpoints_path_file := NodePath()
onready var checkpoints_curve = get_node(checkpoints_path_file).curve

var max_laps = 2
var lap_distances_to_go = [] # so this is an array that stores the distance you have to go depending on the lap you are on (becuase otherwise lag was crazy)
onready var one_lap_distance = checkpoints_curve.get_baked_length()

var is_racing = false


func _ready():
#	checkpoints_curve.get_baked_points() # refreshes the cached points
	for i in range(max_laps, -1, -1):
		var distance : int = i * one_lap_distance
		lap_distances_to_go.append(distance)
#	print(lap_distances_to_go)
	
	for r in ranks_imgs_paths:
		rank_imgs.append(get_node(r))
	set_up_racers()
	
	$AnimationPlayer.play("countdown")


func _process(delta):
	if is_racing:
		calculate_rankings()


func set_up_racers():
	for node in racer_nodes:
		var r = get_node(node)
		var is_player = r.name == "PlayerCar"
		racers.append(Racer.new(r, is_player))


func _on_FinishLine_body_entered(body):
	# Car has passed finish line
	var r = look_for_racer(body.get_parent().name)
	if not (r == null):
		print(body.get_parent().name)
		r.increment_lap(max_laps)
	

func look_for_racer(racer_name : String) -> Racer:
	print(racer_name)
	for r in racers:
		if r.racer.name == racer_name:
			return r
	return null


func calculate_rankings():
	for r in racers:
		# The checkpoints path starts at the end of the finish line, travels through the track, and ends where the race begins.
		# So now when the offset is calculated, racers with smaller offsets are closer to finishing their lap.
		
		# The point on the line the racer is closest to
#		var point_on_line = checkpoints_curve.get_closest_point(r.racer.get_node("CarTemplate").global_position)
		# The offset from the start of the line the racer is on
		var dist : int = checkpoints_curve.get_closest_offset(r.racer.find_node("CarTemplate").global_position)
		r.rank = dist + lap_distances_to_go[r.laps-1] # note this is a temporary place holder rank used to sort the racers
	
	# Sort array of racers 
	racers.sort_custom(Racer, "sort_position")
	for r in range(len(racers)):
		racers[r].set_rank(r+1) # r+1 since ranks are 1 to 6, but r is 0 to 5
#		rank_imgs[r].global_position = racers[r].racer.get_node("CarTemplate").global_position # have placement follow racer 


func start_racers():
	for r in racers:
		r.start_racer()


func start_race():
	is_racing = true
	start_racers()
