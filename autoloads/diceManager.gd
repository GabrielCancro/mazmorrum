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

func get_have_dice_node(dc):
	var index = GAME.get_node("DiceSet").results.find(dc)
	if index == -1: return null
	else: return DICE_NODES[index]

func consume_dice(dc_node):
	DICE_SET.consume_dice(dc_node)

func restore_dice_by_type(dc_type):
	DICE_SET.restore_dice_by_type(dc_type)
