extends Control

var room_node
var map = {}
var last_nodes = []
var new_nodes = []
var rooms_amount = 10
var percent_of_door = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	room_node = $room
	remove_child($room)
	$Button.connect("button_down",self,"generate_step_map")
	$Button2.connect("button_down",self,"reset_map")
	reset_map()
	#$Button2.connect("button_down",self,"on_reset")

func generate_step_map():
	MapGenerator.next_step_generation()
	recreate_room_nodes()

func reset_map():
	MapGenerator.clear_map()
	MapGenerator.generate_new_map(int($LineEdit.text),false)
	recreate_room_nodes()

func recreate_room_nodes():
	for rn in $Rooms.get_children():
		$Rooms.remove_child(rn)
		rn.queue_free()
	for room_name in MapGenerator.map:
		var room_data = MapGenerator.map[room_name]
		var x = room_data.posX
		var y = room_data.posY
		var new_room = room_node.duplicate()
		new_room.rect_position += new_room.rect_size*Vector2(x,y) 
		new_room.name = "room_"+str(x)+"_"+str(y)
		new_room.get_node("Label").text = str(x)+","+str(y)
		new_nodes.append(new_room.name)
		if room_data.is_creted_in_last_step: new_room.modulate = Color(1,1,.5,1)
		$Rooms.add_child(new_room)
		for d in room_data.doors.keys():
			new_room.get_node(d).visible = room_data.doors[d]
