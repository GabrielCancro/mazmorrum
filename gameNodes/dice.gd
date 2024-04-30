extends Control

var faces = ["SW","SW","SW","AX","",""]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"roll")

func roll():
	var index = 0
	for i in range(10):
		$Label.text = "?"
		yield(get_tree().create_timer(.05),"timeout")
		index = randi()%faces.size() 
		$Label.text = faces[index]
		rect_rotation = rand_range(-10,10)
		yield(get_tree().create_timer(.05),"timeout")
	rect_rotation = 0
