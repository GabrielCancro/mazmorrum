extends Control

var token_data
var action_data
var action_index = -1
var action_reqs = []
var is_all_asigned = false

func _ready():
	pass
	#Effector.add_hint(self,$bgHint)
	#Effector.add_hint($btn_action1,$btn_action1/bgHint)
	#Effector.add_hint($btn_action2,$btn_action2/bgHint)

func set_data(tk,index):
	token_data = tk
	action_index = index
	action_data = tk.actions[index]
	$Label.text = action_data.name.to_upper()
	action_reqs = []
	for rn in get_node("HBoxReq").get_children():
		if rn.get_index()>action_data.req.size()-1: rn.visible = false
		else: 
			action_reqs.append({"type":action_data.req[rn.get_index()],"asigned":false })
			rn.get_node("img").texture = load("res://assets/dices/"+action_data.req[rn.get_index()]+".png")
			rn.connect("button_down",self,"on_req_click",[rn])

func on_req_click(rn_node):
	var index = rn_node.get_index()
	action_reqs[index].asigned
	if !action_reqs[index].asigned:
		var check_req = DungeonManager.check_have_dice(action_reqs[index].type)
		if check_req: 
			set_dice_asigned(index,true)
			DungeonManager.consume_dice(action_reqs[index].type)
		else:
			Effector.add_float_text("NO TIENES DADOS!",.5,.2)
	else:
		set_dice_asigned(index,false)
		DungeonManager.restore_dices(action_reqs[index].type)

func set_dice_asigned(index,val):
	action_reqs[index].asigned = val
	$HBoxReq.get_child(index).modulate.b = .5 if val else 1
	is_all_asigned = true
	for req in action_reqs:
		if req.asigned == false: is_all_asigned = false
	print("IS ALL ASIGNED ",is_all_asigned)
