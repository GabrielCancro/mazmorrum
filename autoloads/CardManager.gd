extends Node

var current_card
var current_action
signal end_action

var CARD_BASIC_DATA = {
	"trap": {"is_dangerous":true, "actions":[
				{"name":"disarm","req":["HN","HN"]},
				{"name":"evade","req":["BT","BT"]}
			]},
	"enemy": {"is_dangerous":true, "actions":[
				{"name":"attack","req":["SW","SW"]},
				{"name":"evade","req":["BT",]}
			]},
}

func get_card_data(type):
	var data = CARD_BASIC_DATA[type].duplicate()
	data["type"] = type
	data["action_asigned"] = null
	data["card_ref"] = null
	return data

func get_four_random_cards():
	randomize()
	var cards = []
	var keys = CARD_BASIC_DATA.keys()
	for i in range(4):
		if randi()%100 < 50: cards.append(null)
		else: cards.append( get_card_data( keys[randi()%keys.size()] ) )
	return cards

func run_action(card):
	current_card = card
	Effector.resalt_card(card.card_ref)
	yield(get_tree().create_timer(.5),"timeout")
	var method = "ac_"+card.type+"_"
	if card.action_asigned != null:
		current_action = card.actions[card.action_asigned]
		method += current_action.name
	else: 
		current_action = null
		method += "none"
	if has_method(method): call(method)
	card.card_ref.clear_asigned_actions()
	yield(get_tree().create_timer(.75),"timeout")
	Effector.unresalt_card(card.card_ref)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_action")

func ac_enemy_none(): PlayerManager.damage_player()
func ac_enemy_attack(): current_card.card_ref.destroy_card()
func ac_enemy_evade(): pass

func ac_trap_none(): PlayerManager.damage_player()
func ac_trap_disarm(): current_card.card_ref.destroy_card()
func ac_trap_evade(): pass
