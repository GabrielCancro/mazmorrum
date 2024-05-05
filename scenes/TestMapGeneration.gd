extends Control

var room_node
var map = {}
var last_nodes = []
var new_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	room_node = $room
	remove_child($room)
	create_new_room(0,0)
	$Button.connect("button_down",self,"generate_step_map")
	$Button2.connect("button_down",self,"on_reset")

func generate_step_map():
	last_nodes = new_nodes
	new_nodes = []
	for r in last_nodes:
		var room_data = map[r]
		room_data.node_ref.modulate = Color(1,1,1,1)
		if room_data.doors.up: create_new_room(room_data.posX,room_data.posY-1)
		if room_data.doors.down: create_new_room(room_data.posX,room_data.posY+1)
		if room_data.doors.left: create_new_room(room_data.posX-1,room_data.posY)
		if room_data.doors.right: create_new_room(room_data.posX+1,room_data.posY)

func create_new_room(x,y):
	if "room_"+str(x)+"_"+str(y) in map: return
	var new_room = room_node.duplicate()
	new_room.rect_position += new_room.rect_size*Vector2(x,y) 
	new_room.name = "room_"+str(x)+"_"+str(y)
	new_room.get_node("Label").text = str(x)+","+str(y)
	new_nodes.append(new_room.name)
	new_room.modulate = Color(1,1,.5,1)
	add_child(new_room)
	var room_data = {
		"posX":x,
		"posY":y,
		"doors":{"up":(randi()%100<30),"down":(randi()%100<30),"left":(randi()%100<30),"right":(randi()%100<30)},
		"node_ref":new_room
	}
	if x==0 && y==0: room_data.doors = {"up":true,"down":true,"left":true,"right":true}
	map["room_"+str(x)+"_"+str(y)] = room_data
	connect_disconnected_doors(room_data)
	print(new_room.name,": ",room_data.doors)

func connect_disconnected_doors(room_data):
	var test_room_data = get_room_data(room_data.posX-1,room_data.posY)
	if test_room_data:
		if test_room_data.doors.right: room_data.doors.left = true
		if room_data.doors.left: test_room_data.doors.right = true
		update_visual_doors(test_room_data)
		
	test_room_data = get_room_data(room_data.posX+1,room_data.posY)
	if test_room_data:
		if test_room_data.doors.left: room_data.doors.right = true
		if room_data.doors.right: test_room_data.doors.left = true
		update_visual_doors(test_room_data)
		
	test_room_data = get_room_data(room_data.posX,room_data.posY-1)
	if test_room_data:
		if test_room_data.doors.down: room_data.doors.up = true
		if room_data.doors.up: test_room_data.doors.down = true
		update_visual_doors(test_room_data)
		
	test_room_data = get_room_data(room_data.posX,room_data.posY+1)
	if test_room_data:
		if test_room_data.doors.up: room_data.doors.down = true
		if room_data.doors.down: test_room_data.doors.up = true
		update_visual_doors(test_room_data)
	update_visual_doors(room_data)

func get_room_data(x,y):
	if "room_"+str(x)+"_"+str(y) in map:
		return map["room_"+str(x)+"_"+str(y)]
	else:
		return null

func update_visual_doors(room_data):
	for d in room_data.doors.keys():
		room_data.node_ref.get_node(d).visible = room_data.doors[d]

func on_reset():
	get_tree().reload_current_scene()
