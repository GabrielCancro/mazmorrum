extends Control

var data

func _ready(): 
	$Button.connect("button_down",self,"print_card_data")

func set_data(room_data):
	data = room_data
	$Label.text = str(data.posX)+" , "+str(data.posY)
	#if data.state == "ask": Effector.appear(self)

func create_tokens():
	#print("CREATE TOKENS: ",data.tokens)
	Utils.remove_all_childs($Tokens)
	for index in range(data.tokens.size()):
		var token_data = data.tokens[index]
		if !token_data: continue
		var token_node = preload("res://gameNodes/CardRoom.tscn").instance()
		set_token_position(token_node,index)
		token_data["room_ref"] = self
		token_data["token_ref"] = token_node
		token_data["token_index"] = index
		token_node.set_data(token_data)
		$Tokens.add_child(token_node)
		if data.state == "ask": Effector.appear(token_node)

func update_token_actions(dices):
	for tk in $Tokens.get_children():
		tk.check_actions_requeriment(dices)

func set_token_position(token_node,index):
	var padding = 5
	var tile = [Vector2(-1,-1),Vector2(1,-1),Vector2(-1,1),Vector2(1,1)][index]
	token_node.rect_position -= token_node.rect_size/2
	token_node.rect_position += tile*(token_node.rect_size/2+Vector2(padding,padding))

func print_card_data():
	for tk in data.tokens:
		if !tk: continue
		var line = ""
		line += str(tk.token_index)+"."+tk.type+"  "
		for ac in tk.actions:
			line+= str(ac.action_index)+"."+ac.name
			if ac.all_req_assigned: line+="(ALL_ASSIGNED)"
			line+="  "
		print(line)
