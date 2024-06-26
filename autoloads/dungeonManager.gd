extends Node

var GAME
var MINIMAP
var ENABLED_INPUT = true

func _initialize_dungeon_manager(_GAME):
	GAME = _GAME
	MapManager.load_current_player_room()

func disable_input(time):
	if !ENABLED_INPUT: return
	ENABLED_INPUT = false
	GAME.get_node("BG_INPUT").visible = true
	yield( get_tree().create_timer(time),"timeout")
	ENABLED_INPUT = true
	GAME.get_node("BG_INPUT").visible = false

func on_door_click(code):
	if PlayerManager.player_data_inc("mv",-1): 
		var nextX = MapManager.current_room.data.posX
		var nextY = MapManager.current_room.data.posY
		if code=="up": nextY -= 1
		if code=="down": nextY += 1
		if code=="left": nextX -= 1
		if code=="right": nextX += 1
		var next_room_data = MapManager.get_room_data( nextX, nextY )
		if next_room_data: 
			PlayerManager.get_player_data().posX = nextX
			PlayerManager.get_player_data().posY = nextY
			MapManager.load_current_player_room()
	else:
		Effector.add_float_text("wr_no_movement",.5,.25)
