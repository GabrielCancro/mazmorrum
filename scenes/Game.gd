extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(ev):
	var dir = Vector2()
	if Input.is_action_just_pressed("ui_right"): dir.x = 1
	if Input.is_action_just_pressed("ui_left"): dir.x = -1
	if Input.is_action_just_pressed("ui_up"): dir.y = -1
	if Input.is_action_just_pressed("ui_down"): dir.y = 1
	
	if dir.length()!=0:
		var room = $Map.get_room($Map/PlayerToken.map_position.x+dir.x, $Map/PlayerToken.map_position.y+dir.y)
		if room:
			$Map/PlayerToken.map_position += dir
			Effector.move_to($Map/PlayerToken,room.position)
