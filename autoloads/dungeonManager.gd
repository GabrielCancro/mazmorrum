extends Node

var GAME
var MAP
var PLAYER_TOKEN:PlayerToken
var current_player_index = 0
var ENABLED_INPUT = true

# Called when the node enters the scene tree for the first time.
func _initialize_dungeon_manager(_GAME):
	GAME = _GAME
	MAP = GAME.get_node("Map")
	PLAYER_TOKEN = GAME.get_node("Map/PlayerToken")

func move_player_to_room(room):
	PLAYER_TOKEN.map_position = room.data.map_position
	Effector.move_to( PLAYER_TOKEN, room.position)
	var pos = room.data.map_position
	MAP.try_explore_room(pos.x+1,pos.y)
	MAP.try_explore_room(pos.x-1,pos.y)
	MAP.try_explore_room(pos.x,pos.y+1)
	MAP.try_explore_room(pos.x,pos.y-1)

func get_current_room():
	var pos = PLAYER_TOKEN.map_position
	return MAP.get_room(pos.x,pos.y)

func disable_input(time):
	if !ENABLED_INPUT: return
	ENABLED_INPUT = false
	GAME.get_node("CanvasLayerBG/BG_INPUT").visible = true
	yield( get_tree().create_timer(time),"timeout")
	ENABLED_INPUT = true
	GAME.get_node("CanvasLayerBG/BG_INPUT").visible = false
	
