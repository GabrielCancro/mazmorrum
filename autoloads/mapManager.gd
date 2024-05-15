extends Node

var GAME
var MINIMAP
var map
var current_room
var last_room_coord

signal load_new_room(room_data)

# Called when the node enters the scene tree for the first time.
func _initialize_map(_GAME):
	GAME = _GAME
	MINIMAP = GAME.get_node("Minimap")
	generate_map(1)

func generate_map(lvl):
	map = MapGenerator.generate_new_map(6+lvl*2)

func get_room_data(x,y):
	var room_key = "room_"+str(x)+"_"+str(y)
	if room_key in map: return map[room_key]
	else: return null

func get_current_room_data():
	return current_room.data

func load_room(x,y):
	if current_room:
		last_room_coord = Vector2(current_room.data.posX,current_room.data.posY)
		Effector.map_room_out_fx(current_room,x,y)
	#	GAME.get_node("ActionList").modulate.a = 0
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
	emit_signal("load_new_room",new_room.data)

func load_current_player_room():
	var nextX = PlayerManager.get_player_data().posX
	var nextY =PlayerManager.get_player_data().posY
	load_room(nextX, nextY)

func update_room_exploration_state(x,y):
	if current_room.data.posX==x && current_room.data.posY==y:
		current_room.data.state = "safe"
	else:
		var test_room_data = get_room_data(x,y)
		if test_room_data && test_room_data.state=="unexplored": 
			test_room_data.state = "ask" 
