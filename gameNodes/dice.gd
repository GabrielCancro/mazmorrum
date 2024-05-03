extends Control

var faces = ["SW","SW","HN","BT","",""]
var index = 0
var value = ""
var is_disabled

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

func set_disabled(val):
	is_disabled = val
	if is_disabled: modulate.a = .5
	else: modulate.a = 1

func get_disabled():
	return is_disabled
