extends Control

var token_data
var action_selected = 0

func _ready():
	Effector.add_hint(self,$bgHint)
	Effector.add_hint($btn_action1,$btn_action1/bgHint)
	Effector.add_hint($btn_action2,$btn_action2/bgHint)

func set_token_data(tk=token_data):
	token_data = tk
	$Label.text = tk.type.to_upper()
	$bgSelected.visible = (action_selected!=0)
	set_an_action(1)
	set_an_action(2)

func set_an_action(index):
	var ac_btn = get_node("btn_action"+str(index))
	ac_btn.visible = false
	if token_data.actions.size()<index: return
	if action_selected != 0 && action_selected != index: return
	ac_btn.visible = true
	var ac = token_data.actions[index-1]
	ac_btn.get_node("Label").text = ac.name
	ac_btn.connect("button_down",self,"on_action_click",[ac_btn,index])
	for rn in ac_btn.get_node("HBoxReq").get_children():
		if rn.get_index()>ac.req.size()-1: rn.visible = false
		else: rn.texture = load("res://assets/dices/"+ac.req[rn.get_index()]+".png")

func on_action_click(ac_btn,index):
	var tk = token_data
	var ac = tk.actions[index-1]
	if action_selected==0:
		var check_req = check_action_requeriment( DungeonManager.get_current_dices(), ac)
		if check_req: 
			DungeonManager.consume_dices(ac.req)
			select_action(index)
		else:
			Effector.add_float_text("NO TIENES DADOS!",.5,.2)
	else:
		select_action(0)
		DungeonManager.restore_dices(ac.req)
	#tk.token_ref.on_action_click(tk,ac)

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

func select_action(index):
	action_selected = index
	set_token_data()
