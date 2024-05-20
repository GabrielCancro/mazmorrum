extends Node

var current_card
var actions_to_run = []
signal end_all_actions

var CARD_BASIC_DATA = {
	"trap": {"is_dangerous":true, "actions":[
				{"name":"disarm","req":["HN","HN"]},
				{"name":"evade","req":["BT","BT"]}
			]},
	"enemy": {"is_dangerous":true, "hp":1, "actions":[
				{"name":"attack","req":["SW","SW"]},
				{"name":"evade","req":["BT",]}
			]},
}

func get_card_data(type):
	var data = CARD_BASIC_DATA[type].duplicate(true)
	data["type"] = type
	for ac in data["actions"]: 
		ac["all_req_assigned"] = false
		ac["ref_node"] = null
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
	print("RUN ACTION ",current_card.token_index,".",current_card.type)
	Effector.resalt_card(card.card_ref)
	yield(get_tree().create_timer(.5),"timeout")
	if card.actions.size()==0: yield(get_tree().create_timer(.75),"timeout")
	for ac in card.actions: 
		if ac.all_req_assigned:
			var action_method = "ac_"+card.type+"_"+ac.name
			print("_____",action_method)
			if has_method(action_method): call(action_method)
			else: print("NO HAY METHODO PARA LA ACCION ",action_method)
			Effector.move_yoyo_rect(ac.action_ref,ac.action_ref.rect_position+Vector2(20,0))
			#Effector.add_float_text(action_method,0.5,0.25)
			Effector.resalt_action(ac.action_ref)
			yield(get_tree().create_timer(1),"timeout")
	var card_method = "resolve_"+card.type
	print("========",card_method)
	if has_method(card_method): call(card_method)
	else: print("NO HAY METHODO PARA LA ACCION ",card_method)
	##card.card_ref.clear_asigned_actions()
	yield(get_tree().create_timer(.1),"timeout")
	Effector.unresalt_card(card.card_ref)
	yield(get_tree().create_timer(.1),"timeout")
	emit_signal("end_all_actions")

####ENEMY
func ac_enemy_attack(): 
	current_card.hp -= 1
	Effector.shake(current_card.card_ref.get_node("img"))
func ac_enemy_evade(): 
	current_card["is_evaded"] = true
func resolve_enemy(): 
	if current_card.hp <= 0: current_card.card_ref.destroy_card()
	elif "is_evaded" in current_card: current_card.erase("is_evaded")
	else: PlayerManager.damage_player()

func ac_trap_disarm(): 
	current_card["is_disarmed"] = true
	#Effector.shake(current_card.card_ref.get_node("img"))
func ac_trap_evade(): current_card["is_evaded"] = true
func resolve_trap():
	if "is_disarmed" in current_card: current_card.card_ref.destroy_card()
	elif "is_evaded" in current_card: current_card.erase("is_evaded")
	else: PlayerManager.damage_player()
