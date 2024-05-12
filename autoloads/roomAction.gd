extends Node

var MAP

func _initialize_room_action(GAME):
	return
	#MAP = GAME.get_node("Map")

func on_enter_empty(room):
	DungeonManager.move_player_to_room(room)

func on_interact_empty(room):
	Effector.appear(DungeonManager.PLAYER_TOKEN)

func on_enter_trap(room):
	DungeonManager.PLAYER_TOKEN.run_dices({"dif":room.data.dif})
	var dice_value = yield(DungeonManager.PLAYER_TOKEN,"on_dices")
	DungeonManager.move_player_to_room(room)
	if dice_value < room.data.dif:
		DungeonManager.disable_input(.5)
		yield(get_tree().create_timer(.5),"timeout")
		DungeonManager.damage_player(1)

func on_enter_enemy(room):
	DungeonManager.PLAYER_TOKEN.run_dices({"dif":room.data.dif})
	var dice_value = yield(DungeonManager.PLAYER_TOKEN,"on_dices")
	if dice_value >= room.data.dif:
		room.damage_enemy()
	else:
		room.enemy_attack()

func on_enter_chest(room):
	on_enter_empty(room)
