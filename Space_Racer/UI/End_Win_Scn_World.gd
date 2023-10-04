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
	
	$Starfox/Camera.current = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
