extends Node

var MAP


# Called when the node enters the scene tree for the first time.
func _initialize_dungeon_manager(GAME):
	MAP = GAME.get_node("Map")
	print(MAP)


func move_player(dir):
	var room = MAP.get_room(MAP.get_node("PlayerToken").map_position.x+dir.x, MAP.get_node("PlayerToken").map_position.y+dir.y)
	if room:
		MAP.get_node("PlayerToken").map_position += dir
		Effector.move_to(MAP.get_node("PlayerToken"),room.position)
		var pos = MAP.get_node("PlayerToken").map_position
		MAP.try_explore_room(pos.x+1,pos.y)
		MAP.try_explore_room(pos.x-1,pos.y)
		MAP.try_explore_room(pos.x,pos.y+1)
		MAP.try_explore_room(pos.x,pos.y-1)
