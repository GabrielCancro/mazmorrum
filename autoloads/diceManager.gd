extends Node

var GAME
var DICE_SET
var DICE_NODES = []

var dice_types = {
	"basic":["SW","SW","HN","BT","",""]
}

func _initialize_dice_manager(_GAME):
	GAME = _GAME
	DICE_SET = GAME.get_node("DiceSet")
	DICE_NODES = DICE_SET.get_dice_nodes()
	MapManager.load_current_player_room()

func get_dice_faces(dice_type):
	return dice_types[dice_type]

func get_dice_node_of_type(dc_type):
	for dn in DICE_NODES:
		if dn.is_disabled: continue
		if dn.value==dc_type: return dn
	return null

func consume_dice(dc_node):
	if !dc_node.is_disabled: dc_node.set_disabled(true)

func restore_dice_by_type(dc_type):
	for dn in DICE_NODES:
		if !dn.is_disabled(): continue
		if dn.value==dc_type:
			dn.set_disabled(false)
			break
