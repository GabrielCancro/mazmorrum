extends Control

var data

# Called when the node enters the scene tree for the first time.
func set_data(room_data):
	data = room_data

func _ready():
	print("ROOM DATA SETED ",data)
