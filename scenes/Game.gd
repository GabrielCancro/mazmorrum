extends Control

func _ready():
	PlayerManager._initialize_player_manager(self)
	Effector._initialize_effector(self)
	MapManager._initialize_map(self)
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
		print("RUN ACTION ",card.type)
		CardManager.run_action(card)
		yield(CardManager,"end_action")
	yield(get_tree().create_timer(.5),"timeout")
	$DiceSet.reset_set()
	PlayerManager.set_next_player()
	MapManager.load_current_player_room()
