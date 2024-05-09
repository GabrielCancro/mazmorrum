extends Control

var room_node
var map = {}
var last_nodes = []
var new_nodes = []
var rooms_amount = 10
var percent_of_door = 30

# Called when the node enters the scene tree for the first time.
func generate_new_map(_rooms_amount,generate_by_steps=false):
	rooms_amount = _rooms_amount
	randomize()
	create_new_room(0,0)
	if !generate_by_steps:
		while rooms_amount>0: next_step_generation()
		next_step_generation()
	return map

func clear_map():
	map = {}
	last_nodes = []
	new_nodes = []

func next_step_generation():
	last_nodes = new_nodes
	if rooms_amount>0 && last_nodes.size()==0: add_one_random_door()
	if rooms_amount<=0: remove_unconnected_doors()
	new_nodes = []
	for r in last_nodes:
		var room_data = map[r]
		room_data.is_creted_in_last_step = false
		if room_data.doors.up: create_new_room(room_data.posX,room_data.posY-1)
		if room_data.doors.down: create_new_room(room_data.posX,room_data.posY+1)
		if room_data.doors.left: create_new_room(room_data.posX-1,room_data.posY)
		if room_data.doors.right: create_new_room(room_data.posX+1,room_data.posY)

func create_new_room(x,y):
	if "room_"+str(x)+"_"+str(y) in map: return
	if rooms_amount<=0: return
	rooms_amount -= 1
	new_nodes.append("room_"+str(x)+"_"+str(y))
	var room_data = {
		"posX":x,
		"posY":y,
		"doors":{"up":(randi()%100<percent_of_door),"down":(randi()%100<percent_of_door),"left":(randi()%100<percent_of_door),"right":(randi()%100<percent_of_door)},
		"is_creted_in_last_step":true
	}
	if x==0 && y==0: room_data.doors = {"up":true,"down":true,"left":true,"right":true}
	map["room_"+str(x)+"_"+str(y)] = room_data
	connect_disconnected_doors(room_data)

func connect_disconnected_doors(room_data):
	var test_room_data = get_room_data(room_data.posX-1,room_data.posY)
	if test_room_data:
		if test_room_data.doors.right: room_data.doors.left = true
		if room_data.doors.left: test_room_data.doors.right = true
		
	test_room_data = get_room_data(room_data.posX+1,room_data.posY)
	if test_room_data:
		if test_room_data.doors.left: room_data.doors.right = true
		if room_data.doors.right: test_room_data.doors.left = true
		
	test_room_data = get_room_data(room_data.posX,room_data.posY-1)
	if test_room_data:
		if test_room_data.doors.down: room_data.doors.up = true
		if room_data.doors.up: test_room_data.doors.down = true
		
	test_room_data = get_room_data(room_data.posX,room_data.posY+1)
	if test_room_data:
		if test_room_data.doors.up: room_data.doors.down = true
		if room_data.doors.down: test_room_data.doors.up = true

func add_one_random_door():
	while true:
		var rnd_key = map.keys()[randi()%map.keys().size()]
		var room_data = map[rnd_key]
		if !room_data.doors.up:
			room_data.doors.up = true
			create_new_room(room_data.posX,room_data.posY-1)
			return
		elif !room_data.doors.down:
			room_data.doors.down = true
			create_new_room(room_data.posX,room_data.posY+1)
			return
		elif !room_data.doors.left:
			room_data.doors.left = true
			create_new_room(room_data.posX-1,room_data.posY)
			return
		elif !room_data.doors.right:
			room_data.doors.right = true
			create_new_room(room_data.posX+1,room_data.posY)
			return

func remove_unconnected_doors():
	print("REMOVE UNCONNECTED DOORS")
	for room_name in map:
		var room_data = map[room_name]
		var x = room_data.posX
		var y = room_data.posY
		room_data.doors.up = (room_data.doors.up == true) && (get_room_data(x,y-1) != null)
		room_data.doors.down = (room_data.doors.down == true) && (get_room_data(x,y+1) != null)
		room_data.doors.left = (room_data.doors.left == true) && (get_room_data(x-1,y) != null)
		room_data.doors.right = (room_data.doors.right == true) && (get_room_data(x+1,y) != null)

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
