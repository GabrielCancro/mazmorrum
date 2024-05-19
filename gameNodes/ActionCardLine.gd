extends Control

var token_data
var action_data
var action_index = -1
var action_reqs = []

func _ready():
	pass

func set_data(tk,ac_index):
	token_data = tk
	action_index = ac_index	
	action_data = tk.actions[ac_index]
	action_data["action_index"] = ac_index
	action_data["action_ref"] = self
	$Label.text = str(token_data.token_index)+"."+action_data.name.to_upper()
	action_reqs = []
	for rn in get_node("HBoxReq").get_children():
		if rn.get_index()>action_data.req.size()-1: rn.visible = false
		else: 
			action_reqs.append({"type":action_data.req[rn.get_index()],"asigned":false })
			rn.get_node("img").texture = load("res://assets/dices/"+action_data.req[rn.get_index()]+".png")
			rn.connect("button_down",self,"on_req_click",[rn])

func on_req_click(rn_node):
	var req_index = rn_node.get_index()
	action_reqs[req_index].asigned
	if !action_reqs[req_index].asigned:
		var dice_node = DiceManager.get_dice_node_of_type(action_reqs[req_index].type)
		if dice_node: 
			set_dice_assigned(req_index,true)
			DiceManager.consume_dice(dice_node)
		else:
			Effector.add_float_text("wr_no_dice",.5,.2)
	else:
		set_dice_assigned(req_index,false)
		DiceManager.restore_dice_by_type(action_reqs[req_index].type)

func set_dice_assigned(req_index,val):
	action_reqs[req_index].asigned = val
	$HBoxReq.get_child(req_index).modulate.b = .5 if val else 1
	action_data.all_req_assigned = true
	for req in action_reqs:
		if req.asigned == false: action_data.all_req_assigned = false
	$ActiveColor.visible = action_data.all_req_assigned

func clear_action():
	for req_index in action_reqs.size():
		set_dice_assigned(req_index,false)
