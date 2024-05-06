extends Control

var tokens = []
onready var btn_base = $VBox/action

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBox.remove_child(btn_base)

func fill_action_list():
	visible = false
	for ac in $VBox.get_children():
		$VBox.remove_child(ac)
		ac.queue_free()
	yield(get_tree().create_timer(.2),"timeout")
	tokens = MapManager.current_room.data.tokens
	for tk in tokens:
		add_actions_to_list(tk)
	yield(get_tree().create_timer(.1),"timeout")
	Effector.appear(self)
	visible = true

func add_actions_to_list(tk):
	var new_btn = btn_base.duplicate()
	new_btn.get_node("Label").text = tk.type.to_upper()
	new_btn.connect("mouse_entered",self,"on_hint_action",[new_btn,tk,true])
	new_btn.connect("mouse_exited",self,"on_hint_action",[new_btn,tk,false])

	if tk.actions.size()>0:
		var ac = tk.actions[0]
		new_btn.get_node("btn_action1/Label").text = ac.name
		for rn in new_btn.get_node("btn_action1/HBoxReq").get_children():
			if rn.get_index()>ac.req.size()-1: rn.visible = false
			else: rn.texture = load("res://assets/dices/"+ac.req[rn.get_index()]+".png")
	
	if tk.actions.size()>1:
		var ac = tk.actions[1]
		new_btn.get_node("btn_action2/Label").text = ac.name
		for rn in new_btn.get_node("btn_action2/HBoxReq").get_children():
			if rn.get_index()>ac.req.size()-1: rn.visible = false
			else: rn.texture = load("res://assets/dices/"+ac.req[rn.get_index()]+".png")
	else: new_btn.get_node("btn_action2").visible = false
		#new_btn.connect("button_down",self,"on_action_click",[data,ac])
		#new_btn.connect("mouse_entered",self,"on_hint_action",[new_btn,tk,ac,true])
		#new_btn.connect("mouse_exited",self,"on_hint_action",[new_btn,tk,ac,false])
	$VBox.add_child(new_btn)

func on_hint_action(btn,tk,val):
	if val: 
		btn.modulate.b = .5
		tk.token_ref.modulate.b = .5
	else: 
		btn.modulate.b = 1
		tk.token_ref.modulate.b = 1
