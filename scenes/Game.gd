extends Control

var door_buttons_connected = false

func _ready():
	PlayerManager._initialize_player_manager(self)
	Effector._initialize_effector(self)
	MapManager._initialize_map(self)
	DiceManager._initialize_dice_manager(self)
	MapManager.connect("load_new_room",self,"set_door_buttons")
	DungeonManager._initialize_dungeon_manager(self)
	$Button.connect("button_down",self,"on_end_turn")
	yield(get_tree().create_timer(.1),"timeout")

func _input(ev):
	if !DungeonManager.ENABLED_INPUT: return
	var dir = Vector2()
	if Input.is_action_just_pressed("ui_right"): dir.x = 1
	if Input.is_action_just_pressed("ui_left"): dir.x = -1
	if Input.is_action_just_pressed("ui_up"): dir.y = -1
	if Input.is_action_just_pressed("ui_down"): dir.y = 1

func on_end_turn():
	yield(get_tree().create_timer(.5),"timeout")
	for card in MapManager.current_room.data.tokens:
		if !card: continue
		CardManager.run_action(card)
		yield(CardManager,"end_all_actions")
		yield(get_tree().create_timer(.2),"timeout")
	yield(get_tree().create_timer(.5),"timeout")
	$DiceSet.reset_set()
	PlayerManager.set_next_player()
	PlayerManager.player_data_inc("mv",99)
	PlayerManager.player_data_inc("rl",99)
	MapManager.load_current_player_room()

func set_door_buttons(room_data):
	var connecting_buttons = !door_buttons_connected
	for k in room_data.doors.keys():
		get_node("Doors/door_"+k).visible = room_data.doors[k]
		if connecting_buttons:
			door_buttons_connected = true
			get_node("Doors/door_"+k).connect("button_down",DungeonManager,"on_door_click",[k])
