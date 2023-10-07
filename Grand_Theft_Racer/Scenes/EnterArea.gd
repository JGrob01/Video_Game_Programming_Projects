extends Area2D

export(String, FILE, "*.tscn") var change_to_scene

func _ready():
	print("EnterArea Scene : ", change_to_scene)
	$CanvasLayer/Control.change_to_scene = change_to_scene


func _on_Entrance_body_entered(body):
	if body.name == "CarTemplate" and body.player_car:
		$CanvasLayer/Control.visible = true
