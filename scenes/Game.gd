extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	MapManager._initialize_map(self)
	DungeonManager._initialize_dungeon_manager(self)
	RoomAction._initialize_room_action(self)
	yield(get_tree().create_timer(.1),"timeout")
	DungeonManager.move_player_to_room(DungeonManager.get_current_room())

func _input(ev):
	if !DungeonManager.ENABLED_INPUT: return
	var dir = Vector2()
	if Input.is_action_just_pressed("ui_right"): dir.x = 1
	if Input.is_action_just_pressed("ui_left"): dir.x = -1
	if Input.is_action_just_pressed("ui_up"): dir.y = -1
	if Input.is_action_just_pressed("ui_down"): dir.y = 1
	if Input.is_action_just_pressed("ui_accept"): 
		var room = DungeonManager.get_current_room()
		if room:
			if RoomAction.has_method("on_interact_"+room.data.type):
				RoomAction.call("on_interact_"+room.data.type,room)
			else:
				print("NO ACTION ON_INTERACT TO ROOM "+room.data.type)
	
	if dir.length()!=0: 
		var room = $Map.get_room($Map/PlayerToken.map_position.x+dir.x, $Map/PlayerToken.map_position.y+dir.y)
		if room:
			if RoomAction.has_method("on_enter_"+room.data.type):
				RoomAction.call("on_enter_"+room.data.type,room)
			else:
				print("NO ACTION ON_ENTER TO ROOM "+room.data.type)
				DungeonManager.move_player_to_room(room)
