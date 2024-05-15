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
	if PlayerManager.get_player_data().mv<=0: 
		Effector.add_float_text("wr_no_movement",.5,.25)
	else: 
		PlayerManager.player_data_inc("mv",-1)
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

func get_current_dices():
	return GAME.get_node("DiceSet").results

func check_have_dice(dc):
	return GAME.get_node("DiceSet").results.find(dc)!=-1

func consume_dice(dc):
	GAME.get_node("DiceSet").consume_dice(dc)

func restore_dices(dc):
	GAME.get_node("DiceSet").restore_dice(dc)
