extends Control

var data

func _ready(): pass
	

func set_data(room_data):
	data = room_data
	$doorU.connect("button_down",DungeonManager,"on_door_click",["U"])
	$doorD.connect("button_down",DungeonManager,"on_door_click",["D"])
	$doorR.connect("button_down",DungeonManager,"on_door_click",["R"])
	$doorL.connect("button_down",DungeonManager,"on_door_click",["L"])
	$Label.text = str(data.posX)+" , "+str(data.posY)
	#if data.state == "ask": Effector.appear(self)

func create_tokens():
	print("CREATE TOKENS: ",data.tokens)
	for t in $Tokens.get_children():
		$Tokens.remove_child(t)
		t.queue_free()
	for token_data in data.tokens:
		var token_node = preload("res://gameNodes/tokenRoom.tscn").instance()
		token_data.room_ref = self
		token_node.set_data(token_data)
		$Tokens.add_child(token_node)
		if data.state == "ask":
			Effector.appear(token_node)
			yield(get_tree().create_timer(.4),"timeout")

func update_token_actions(dices):
	for tk in $Tokens.get_children():
		tk.check_actions_requeriment(dices)
