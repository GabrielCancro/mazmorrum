extends Node

var MAP

func _initialize_room_action(GAME):
	MAP = GAME.get_node("Map")


func on_enter_empty(room):
	DungeonManager.PLAYER_TOKEN.run_dices({"dif":room.data.dif})
	var dice_value = yield(DungeonManager.PLAYER_TOKEN,"on_dices")
	if dice_value >= room.data.dif:
		DungeonManager.move_player_to_room(room)
		DungeonManager.disable_input(.5)

func on_interact_empty(room):
	Effector.appear(DungeonManager.PLAYER_TOKEN)

func on_enter_trap(room):
	on_enter_empty(room)

func on_enter_enemy(room):
	on_enter_empty(room)

func on_enter_chest(room):
	on_enter_empty(room)
