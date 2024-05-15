extends Node

var GAME
var MINIMAP
var ENABLED_INPUT = true

signal room_changed

func _initialize_dungeon_manager(_GAME):
	GAME = _GAME

func disable_input(time):
	if !ENABLED_INPUT: return
	ENABLED_INPUT = false
	GAME.get_node("BG_INPUT").visible = true
	yield( get_tree().create_timer(time),"timeout")
	ENABLED_INPUT = true
	GAME.get_node("BG_INPUT").visible = false

func on_door_click(code):
	print("DOOR CLICK ",code)
	var nextX = MapManager.current_room.data.posX
	var nextY = MapManager.current_room.data.posY
	if code=="U": nextY -= 1
	if code=="D": nextY += 1
	if code=="L": nextX -= 1
	if code=="R": nextX += 1
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
