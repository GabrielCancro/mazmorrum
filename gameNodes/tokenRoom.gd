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
		{"name":"disarm"},
		{"name":"evade"}
	]
	if type == "enemy":
		return [
		{"name":"attack"},
		{"name":"evade"}
	]

func set_action_buttons():
	var btn = $ActionsContainer/Button
	$ActionsContainer.remove_child(btn)
	for ac in data.actions:
		var new_btn = btn.duplicate()
		new_btn.text = ac.name
		if has_method("on_"+data.type+"_"+ac.name):
			new_btn.connect("button_down",self,"on_"+data.type+"_"+ac.name)
		$ActionsContainer.add_child(new_btn)

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
