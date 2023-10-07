extends Spatial

func _ready():
	$Area.connect("body_entered", self, "area_body_entered")
	pass

func _physics_process(delta):
	rotate_y(PI * 1 / 180)
	pass

func area_body_entered():
	GlobalVariables.damage += 10
	pass
