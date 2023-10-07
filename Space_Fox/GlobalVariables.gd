extends Node

# ----------------------------------------
# WORLD RELATED VARIABLES
# ----------------------------------------

# Dictionary of checkpoint positions 
var checkpoints = {
	0: Vector3(0, 0, 0)
}

# Updated when player passes through a check point
var previous_checkpoint = null
var current_checkpoint = 0

# Updated when a player collects a star
var star_count = 0

# ----------------------------------------
# MOVEMENT RELATED VARIABLES
# ----------------------------------------

# The player's targetted forward speed
var MIN_FLIGHT_SPEED = 10
var MAX_FLIGHT_SPEED = 150
var target_speed = 0

# ----------------------------------------
# PLAYER SLOWED EFFECT
# ----------------------------------------

var slow_time = 0
func is_slowed():
	return slow_time > 0

# ----------------------------------------
# PLAYER RELATED VARIABLES
# ----------------------------------------

# The player's current position
var player_position = Vector3(0, 0, 0)

# The player's current rotation
var player_rotation = Vector3(0, 0, 0)

# The player's current energy level
var energy = 750
var MAX_ENERGY = 750

# The player's current energy level
var damage = 100
var MAX_DAMAGE = 100
var can_take_damage = false
