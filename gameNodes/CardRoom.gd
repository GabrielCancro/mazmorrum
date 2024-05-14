extends Control
class_name CardRoom

var data

func set_data(_data):
	data = _data
	data["card_ref"] = self
	Effector.add_hint_text(self,"ESTA CARTA ES "+data.type)
	set_action_lines()
	update_visual_token()

func update_visual_token():
	$lb_name.text = data.type

func set_action_lines():
	Utils.remove_all_childs($Actions)
	for index in range(data.actions.size()):
		var action_card_line = load("res://gameNodes/ActionCardLine.tscn").instance()
		action_card_line.set_data(data,index)
		$Actions.add_child(action_card_line)

func destroy_card():
	Effector.disappear(self)
	var index = MapManager.current_room.data.tokens.find(data)
	MapManager.current_room.data.tokens[index] = null
	DungeonManager.emit_signal("room_changed")
	yield(get_tree().create_timer(.5),"timeout")
	queue_free()

func clear_asigned_actions():
	for ac in $Actions.get_children():
		ac.clear_action()
