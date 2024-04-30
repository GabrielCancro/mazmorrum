extends Node2D

var room_size = Vector2(350,250)
func _ready():
	create_level(1)

func create_level(lv):
	for r in $Rooms.get_children():
		DataManager.data.rooms.erase(r.name)
		$Rooms.remove_child(r)
		r.queue_free()
	for x in range(10):
		for y in range(10):
			create_room(x,y)

func create_room(x,y):
	var r = preload("res://gameNodes/room.tscn").instance()
	r.position = Vector2(x,y) * room_size * 0.7
	r.data.map_position = Vector2(x,y)
	r.name = "room_"+str(x)+"_"+str(y)
	$Rooms.add_child(r)

func get_room(x,y):
	var node_name = "room_"+str(x)+"_"+str(y)
	return get_node_or_null("Rooms/"+node_name)

func try_explore_room(x,y):
	var test_room = get_room(x,y)
	if test_room: test_room.explore()
