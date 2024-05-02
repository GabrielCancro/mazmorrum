extends Node

var GAME
var map_tile
var map_size = Vector2(10,8)

# Called when the node enters the scene tree for the first time.
func _initialize_map(_GAME):
	GAME = _GAME
	generate_map_data()

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
		"type":"empty",
		"dif":8,
		"hp":2,
		"posX":x,
		"posY":y,
		"doors":{"up":true,"down":true,"left":true,"right":true},
		"tokens":[
			{"type":"trap"},
			{"type":"chest"}
		]
	}

func load_room(x,y):
	var RoomContainer = GAME.get_node("RoomContainer")
	for r in RoomContainer.get_children():
		RoomContainer.remove_child(r)
		r.queue_free()
	var new_room = preload("res://gameNodes/RoomFull.tscn").instance()
	new_room.set_data( get_room_data(x,y) )
	RoomContainer.add_child(new_room)
