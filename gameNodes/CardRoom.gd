extends Control

var data

func set_data(_data):
	data = _data
	data["card_ref"] = self
	#rect_position = data.pos
	#$img_ref.visible = true
	#var img = load("res://gameNodes/tokenImages/img_"+data.type+".tscn").instance()
	#add_child_below_node($img_ref,img)
	#$img_ref.visible = false
	#$MouseArea.connect("mouse_entered",self,"on_mouse_token",[true])
	#$MouseArea.connect("mouse_exited",self,"on_mouse_token",[false])
	set_action_lines()
	update_visual_token()

func update_visual_token():
	$lb_name.text = data.type
#	if data.is_dangerous:
#		Effector.set_shader_outline(get_node("token_image/Image"),Color(1,0,0,1))
#	else: 
#		Effector.set_shader_outline(get_node("token_image/Image"))
	pass

func set_action_lines():
	Utils.remove_all_childs($Actions)
	for index in range(data.actions.size()):
		var action_card_line = load("res://gameNodes/ActionCardLine.tscn").instance()
		action_card_line.set_data(data,index)
		$Actions.add_child(action_card_line)

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
