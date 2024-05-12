extends Control

var data

func set_data(_data):
	data = _data
	rect_position = data.pos
	$img_ref.visible = true
	var img = load("res://gameNodes/tokenImages/img_"+data.type+".tscn").instance()
	add_child_below_node($img_ref,img)
	$img_ref.visible = false
	data.actions = get_actions_by_type(data.type)
	$MouseArea.connect("mouse_entered",self,"on_mouse_token",[true])
	$MouseArea.connect("mouse_exited",self,"on_mouse_token",[false])
	set_action_buttons()
	update_visual_token()

func update_visual_token():
	if data.is_dangerous:
		Effector.set_shader_outline(get_node("token_image/Image"),Color(1,0,0,1))
	else: 
		Effector.set_shader_outline(get_node("token_image/Image"))
	
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
	var btn_action = $MouseArea/ActionsContainer/btn_action
	$MouseArea/ActionsContainer.remove_child(btn_action)
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
		$MouseArea/ActionsContainer.add_child(new_btn)
		$MouseArea/ActionsContainer.rect_position = get_node("token_image/up_point").position + Vector2(-$MouseArea/ActionsContainer.rect_size.x/2,-40)

func on_action_click(token_data,action_data):
	if has_method("on_"+token_data.type+"_"+action_data.name):
		call("on_"+token_data.type+"_"+action_data.name)
	
func on_enemy_attack():
	print("on_enemy_attack")
	destroy_token()

func on_enemy_evade():
	print("on_enemy_evade")
	data.is_dangerous = false
	update_visual_token()

func on_trap_disarm():
	print("on_trap_disarm")
	destroy_token()

func on_trap_evade():
	print("on_trap_evade")
	data.is_dangerous = false
	update_visual_token()
	
func destroy_token():
	$MouseArea/ActionsContainer.visible = false
	Effector.disappear(self)
	data.room_ref.data.tokens.erase(data)
	DungeonManager.emit_signal("room_changed")
	yield(get_tree().create_timer(.5),"timeout")
	print(data.room_ref.data)
	queue_free()

func on_hint(node,text,show):
	$HintLabel.text = text
	$HintLabel.rect_global_position.y = get_node("token_image/up_point").global_position.y - 75
	$HintLabel.visible = show
	if show: node.modulate = Color(.8,.8,1,1)
	else: node.modulate = Color(1,1,1,1)

func on_mouse_token(val):
	$MouseArea/ActionsContainer.visible = val
	$MouseArea/MouseAreaBig.visible = val
	if val: get_node("token_image").modulate = Color(.8,.8,1,1)
	else: get_node("token_image").modulate = Color(1,1,1,1)
