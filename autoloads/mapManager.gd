extends Node

var GAME
var map_tile
var map_size = Vector2(10,8)
var current_room
var last_room_coord

# Called when the node enters the scene tree for the first time.
func _initialize_map(_GAME):
	GAME = _GAME
	generate_map_data()
	load_room(3,3)

func generate_map_data():
	map_tile = []
	for y in range(map_size.y):
		var row = []
		for x in range(map_size.x):
			var room_data = get_default_room_data(x,y)
			row.append(room_data)
		map_tile.append(row)

func get_room_data(x,y):
	if x<0 or x>map_size.x-1: return null
	if y<0 or y>map_size.y-1: return null
	return map_tile[y][x]

func get_default_room_data(x,y):
	return {
		"is_explored":false,
		"posX":x,
		"posY":y,
		"doors":{"up":true,"down":true,"left":true,"right":true},
		"room_ref":null,
		"state":"unexplored", #unexplored, ask, danger, safe
		"tokens":[
			{"type":"trap","pos":Vector2(650,430),"is_dangerous":true},
			{"type":"enemy","pos":Vector2(740,480),"is_dangerous":true}
		]
	}

func load_room(x,y):
	if current_room:
		last_room_coord = Vector2(current_room.data.posX,current_room.data.posY)
		Effector.map_room_out_fx(current_room,x,y)
		GAME.get_node("ActionList").modulate.a = 0
		yield(get_tree().create_timer(.35),"timeout")
	var RoomContainer = GAME.get_node("RoomContainer")
	for r in RoomContainer.get_children():
		RoomContainer.remove_child(r)
		r.queue_free()
	var new_room = preload("res://gameNodes/RoomFull.tscn").instance()
	new_room.set_data( get_room_data(x,y) )
	if last_room_coord: Effector.map_room_in_fx(new_room,x,y)
	RoomContainer.add_child(new_room)
	new_room.create_tokens()
	current_room = new_room
	update_room_exploration_state(x,y)
	update_room_exploration_state(x,y+1)
	update_room_exploration_state(x,y-1)
	update_room_exploration_state(x+1,y)
	update_room_exploration_state(x-1,y)
	DungeonManager.emit_signal("room_changed")
	print("ROOM DATA SETED ",new_room.data)

func update_room_exploration_state(x,y):
	if current_room.data.posX==x && current_room.data.posY==y:
		current_room.data.state = "safe"
	else:
		var test_room_data = get_room_data(x,y)
		if test_room_data && test_room_data.state=="unexplored": 
			test_room_data.state = "ask" 
