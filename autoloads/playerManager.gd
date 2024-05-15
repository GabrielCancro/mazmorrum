extends Node

var GAME
var PLAYER_TOKENS_CONTAINER
var PLAYER_TOKEN:PlayerToken
var current_player_index = 0
var players = [
		{"retrait":1,"hp":6,"hpm":6,"mv":3,"mvm":3,"posX":0,"posY":0},
		{"retrait":2,"hp":6,"hpm":6,"mv":3,"mvm":3,"posX":0,"posY":0}
	]

signal update_player_data(player_data)

func _initialize_player_manager(_GAME):
	GAME = _GAME
	PLAYER_TOKENS_CONTAINER = GAME.get_node("PlayerTokens")
	set_current_player(current_player_index)
	
func get_player_data(index = current_player_index):
	return players[current_player_index]

func get_player_token(index = current_player_index):
	return PLAYER_TOKENS_CONTAINER.get_child(current_player_index)

func damage_player(dam=1):
	var player_data = get_player_data()
	player_data.hp -= 1
	if dam>0: Effector.shake(get_player_token(),5)
	emit_signal("update_player_data",player_data)

func set_current_player(index):
	current_player_index = index
	emit_signal("update_player_data",get_player_data())

func set_next_player():
	current_player_index += 1
	if current_player_index >= players.size():
		current_player_index = 0
	set_current_player(current_player_index)

func set_player_tokens():
	for PT in PLAYER_TOKENS_CONTAINER.get_children():
		if PT.get_index() >= players.size(): 
			PT.visible = false
			continue
		else:
			var pdata = players[PT.get_index()]
			PT.get_node("Image").texture = load("res://assets/retraits/token_retrait"+str(pdata.retrait)+".png")
			PT.visible = check_player_in_current_room(pdata)

func check_player_in_current_room(player_data):
	return( player_data.posX == MapManager.get_current_room_data().posX
		&& player_data.posY == MapManager.get_current_room_data().posY )
