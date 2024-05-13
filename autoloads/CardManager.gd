extends Node

var current_card
var current_action
signal end_action

func run_action(card):
	current_card = card
	Effector.from_scale(card.card_ref)
	Effector.from_color(card.card_ref,Color(1,1,0,1))
	
	var method = "ac_"+card.type+"_"
	print("ASSIGNED ",card.action_asigned)
	if card.action_asigned != null:
		current_action = card.actions[card.action_asigned]
		method += current_action.name
		card.card_ref.clear_asigned_action()
	else: 
		current_action = null
		method += "none"
	print("ACTION TO CALL: ",method)
	if has_method(method): call(method)
	yield(get_tree().create_timer(.75),"timeout")
	emit_signal("end_action")

func ac_enemy_evade():
	print("ENEMY EVADE!!")
