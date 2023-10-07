extends Area2D
############################################
# Hannah Moats
# Sets damage based on speed of vehicle when 
# it collides into the object. Plays collision
# sound when the car takes damage. Collisions 
# only registered if it is a static body or 
# kinematic body, rigidbodies are not registered.
# NOTE the car is a kinematic body.
############################################


# Placement of circle collider based on the height of the car sprite

func _on_DamageDetector_body_entered(body):
	if (body.name == "CarTemplate" and body.player_car) or body.name == "FinishLine":
#		print(body.name)
		# Has collided with itself
		# This works since the damage dector is turned off for cars that are not the player
		pass
	elif not (body is RigidBody2D) and (GlobalVariables.speed > 80):
#		print(body.name)
		# Rigidbody obects are those that can be hit but not cause damage
		GlobalVariables.health -= 0.1 * GlobalVariables.speed # damage is proportional to the speed you are going
		GlobalVariables.take_damage = true
#		print("Health: ", GlobalVariables.health)
		$"../CrashPlayer".play()
