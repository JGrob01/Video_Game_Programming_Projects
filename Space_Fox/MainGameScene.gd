#Author: John Grobaker 
extends WorldEnvironment
var PlanetTexture = load("res://GrobakerAssets/Planets/Planets_Pallet.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	var PlanetMaterial = SpatialMaterial.new()
	PlanetMaterial.albedo_texture = PlanetTexture
	$Asteriods/ring_asteroids.set_surface_material(0, PlanetMaterial)
	$Asteriods/ring_asteroids2.set_surface_material(0, PlanetMaterial)
	$Asteriods/ring_asteroids3.set_surface_material(0, PlanetMaterial)
	$Asteriods/ring_asteroids4.set_surface_material(0, PlanetMaterial)
	$Asteriods/ring_asteroids5.set_surface_material(0, PlanetMaterial)
	$Asteriods/ring_asteroids6.set_surface_material(0, PlanetMaterial)
	$Asteriods/ring_asteroids7.set_surface_material(0, PlanetMaterial)
	$Asteriods/ring_asteroids8.set_surface_material(0, PlanetMaterial)
	$Asteriods/ring_asteroids9.set_surface_material(0, PlanetMaterial)
	
	GlobalVariables.energy = GlobalVariables.MAX_ENERGY
	GlobalVariables.damage = GlobalVariables.MAX_DAMAGE
	GlobalVariables.star_count = 0
	GlobalVariables.current_checkpoint = 0
	
	
	# This code was adding a bunch of checkpoints that don't exist
	#for check in $Checkpoints.get_children():
	#	GlobalVariables.checkpoints[len(GlobalVariables.checkpoints)] = check.transform.origin
	#	pass
	
	#for key in GlobalVariables.checkpoints.keys():
	#	print(key)
	#	print(GlobalVariables.checkpoints[key])
		
func _process(delta):
	if GlobalVariables.current_checkpoint == len(GlobalVariables.checkpoints):
		get_tree().change_scene("res://UI/Win Scene.tscn")
	if (GlobalVariables.star_count + 1) % 5 == 0:
		$StarEffect.play()

#Detector for player to start taking damage
func _on_Area_body_entered(body):
	if body.name == "Starfox":
		GlobalVariables.can_take_damage = true
