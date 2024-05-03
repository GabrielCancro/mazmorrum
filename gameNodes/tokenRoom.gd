extends Control

var data

func set_data(_data):
	data = _data
	rect_position = data.pos
	$Image.texture = load("res://assets/room/tk_"+data.type+".png")
	data.actions = get_actions_by_type(data.type)
	set_action_buttons()

func get_actions_by_type(type):
	if type == "trap":
		return [
		{"name":"disarm","req":["HN","HN"],"used":false},
		{"name":"evade","req":["BT","BT"],"used":false}
	]
	if type == "enemy":
		return [
		{"name":"attack","req":["SW","SW"],"used":false},
		{"name":"evade","req":["BT","BT"],"used":false}
	]

func set_action_buttons():
	var btn = $ActionsContainer/Button
	$ActionsContainer.remove_child(btn)
	for ac in data.actions:
		var new_btn = btn.duplicate()
		new_btn.get_node("Label").text = ac.name + "\n"
		for r in ac.req: new_btn.get_node("Label").text += "."+r+"."
		new_btn.connect("button_down",self,"on_action_click",[data,ac])
		$ActionsContainer.add_child(new_btn)

func on_action_click(token_data,action_data):
	var check_req = check_action_requeriment( DungeonManager.get_current_dices(), action_data)
	if check_req:
		DungeonManager.consume_dices(action_data.req)
		if has_method("on_"+token_data.type+"_"+action_data.name):
			call("on_"+token_data.type+"_"+action_data.name)
	
func on_enemy_attack():
	print("on_enemy_attack")
	destroy_token()

func on_trap_disarm():
	print("on_trap_disarm")
	destroy_token()

func destroy_token():
	$ActionsContainer.visible = false
	Effector.disappear(self)
	data.room_ref.data.tokens.erase(data)
	yield(get_tree().create_timer(.5),"timeout")
	print(data.room_ref.data)
	queue_free()

func check_action_requeriment(dices,action):
	var dices_count = {}
	for d in dices: 
		if !d in dices_count: dices_count[d] = 0
		dices_count[d] += 1
	for r in action.req:
		if !r in dices_count: return false
		if dices_count[r] <= 0: return false
		else: dices_count[r] -= 1
	return true
