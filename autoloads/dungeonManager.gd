extends Node

var GAME
var MAP
var CAMERA:Camera2D
var UI
var PLAYER_TOKEN:PlayerToken
var current_player_index = 0
var ENABLED_INPUT = true

signal update_player_data(player_data)

# Called when the node enters the scene tree for the first time.
func _initialize_dungeon_manager(_GAME):
	GAME = _GAME
	#MAP = GAME.get_node("Map")
	#PLAYER_TOKEN = GAME.get_node("Map/PlayerToken")
	#CAMERA = PLAYER_TOKEN.get_node("Camera2D")
	UI = GAME.get_node("CL_UI")
	damage_player(0)

func move_player_to_room(room):
	DungeonManager.disable_input(.3)
	PLAYER_TOKEN.map_position = room.data.map_position
	PLAYER_TOKEN.z_index = room.z_index + 1
	Effector.move_to( PLAYER_TOKEN, room.position+Vector2(0,100))
	var pos = room.data.map_position
	MAP.try_explore_room(pos.x+1,pos.y)
	MAP.try_explore_room(pos.x-1,pos.y)
	MAP.try_explore_room(pos.x,pos.y+1)
	MAP.try_explore_room(pos.x,pos.y-1)
	update_rooms_alpha()

func get_current_room():
	var pos = PLAYER_TOKEN.map_position
	return MAP.get_room(pos.x,pos.y)

func disable_input(time):
	if !ENABLED_INPUT: return
	ENABLED_INPUT = false
	GAME.get_node("CL_BG/BG_INPUT").visible = true
	yield( get_tree().create_timer(time),"timeout")
	ENABLED_INPUT = true
	GAME.get_node("CL_BG/BG_INPUT").visible = false
	
func damage_player(dam=1):
	var pdata = DataManager.get_current_player_data()
	pdata.hp -= 1
	UI.get_node("BG_DAMAGE").visible = true
	UI.get_node("BG_DAMAGE").modulate.a = .5
	Effector.disappear(UI.get_node("BG_DAMAGE"))
	emit_signal("update_player_data",pdata)

func update_rooms_alpha():
	for r in MAP.get_node("Rooms").get_children():
		if r.modulate.a > 0:
			if r.z_index > PLAYER_TOKEN.z_index: r.modulate.a = .5
			else: r.modulate.a = 1
