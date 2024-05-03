extends Control

var faces = ["SW","SW","SW","AX","",""]
var index = 0
var value = ""

func _ready():
	pass
	#$Button.connect("button_down",self,"roll")

func roll():
	for i in range(10):
		$Label.text = "??"
		index = randi()%faces.size() 
		value = faces[index]
		rect_rotation = rand_range(-10,10)
		yield(get_tree().create_timer(.1),"timeout")
	$Label.text = value
	rect_rotation = 0
