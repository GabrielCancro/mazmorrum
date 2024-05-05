extends Control

var data

func set_data(_data):
	data = _data
	rect_position = data.pos
	$img_ref.visible = true
	var img = load("res://gameNodes/tokenImages/img_"+data.type+".tscn").instance()
	add_child_below_node($img_ref,img)
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
	var btn_action = $ActionsContainer/btn_action
	$ActionsContainer.remove_child(btn_action)
	var total_size = 0
	for ac in data.actions:
		var new_btn = btn_action.duplicate()
		for rn in new_btn.get_node("HBoxReq").get_children():
			if rn.get_index()>ac.req.size()-1: rn.visible = false
			else: rn.texture = load("res://assets/dices/"+ac.req[rn.get_index()]+".png")
		new_btn.rect_min_size = Vector2(14+24*ac.req.size(),40)
		new_btn.connect("button_down",self,"on_action_click",[data,ac])
		new_btn.connect("mouse_entered",self,"on_hint",[new_btn,ac.name,true])
		new_btn.connect("mouse_exited",self,"on_hint",[new_btn,ac.name,false])
		$ActionsContainer.add_child(new_btn)
		$ActionsContainer.rect_position = get_node("token_image/up_point").position + Vector2(-$ActionsContainer.rect_size.x/2,-40)

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

func on_hint(node,text,show):
	$HintLabel.text = text
	$HintLabel.rect_global_position.y = get_node("token_image/up_point").global_position.y - 75
	$HintLabel.visible = show
	if show: node.modulate = Color(.8,.8,1,1)
	else: node.modulate = Color(1,1,1,1)
