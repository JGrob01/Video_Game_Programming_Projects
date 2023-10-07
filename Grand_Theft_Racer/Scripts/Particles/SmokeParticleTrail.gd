extends Particles2D
#######################################
# Hannah Moats
# Script to control what happens to the 
# smoke particles over their lifetime. Once
# they are done emitting they are freed. 
#######################################

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true) # this way, the particles are placed correctly and do not follow car
	pass 


func _process(delta):
	# Remove particles when they are done emitting 
	if not emitting:
		queue_free()

