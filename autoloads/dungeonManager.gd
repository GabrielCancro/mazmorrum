extends Node

var GAME
var MINIMAP
var PLAYER_TOKEN:PlayerToken
var current_player_index = 0
var ENABLED_INPUT = true

signal update_player_data(player_data)

# Called when the node enters the scene tree for the first time.
func _initialize_dungeon_manager(_GAME):
	GAME = _GAME
	PLAYER_TOKEN = GAME.get_node("PlayerToken")
	MINIMAP = GAME.get_node("Minimap")
	damage_player(0)

func disable_input(time):
	if !ENABLED_INPUT: return
	ENABLED_INPUT = false
	GAME.get_node("BG_INPUT").visible = true
	yield( get_tree().create_timer(time),"timeout")
	ENABLED_INPUT = true
	GAME.get_node("BG_INPUT").visible = false
	
func damage_player(dam=1):
	var pdata = DataManager.get_current_player_data()
	pdata.hp -= 1
	GAME.get_node("BG_DAMAGE").visible = true
	GAME.get_node("BG_DAMAGE").modulate.a = .5
	Effector.disappear(GAME.get_node("BG_DAMAGE"))
	emit_signal("update_player_data",pdata)

func on_door_click(code):
	print("DOOR CLICK ",code)
	var nextX = MapManager.current_room.data.posX
	var nextY = MapManager.current_room.data.posY
	if code=="U": nextY -= 1
	if code=="D": nextY += 1
	if code=="L": nextX -= 1
	if code=="R": nextX += 1
	var next_room_data = MapManager.get_room_data( nextX, nextY )
	if next_room_data: MapManager.load_room(nextX, nextY)
	MINIMAP.update_minimap()
