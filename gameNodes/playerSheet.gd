extends Control

var item_dropping_node
var item_dropping_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$ItemInfo.visible = false
	PlayerManager.connect("update_player_data",self,"update_player")
	for it in $Items.get_children(): 
		(it as Button).connect("button_down",self,"on_click_down_item",[it.get_index(),it])
		(it as Button).connect("button_up",self,"on_click_up_item",[it.get_index(),it])
		(it as Button).connect("mouse_entered",self,"on_mouse_entered_item",[it.get_index(),it])
		(it as Button).connect("mouse_exited",self,"on_mouse_exited_item",[it.get_index(),it])
		#var item_data = PlayerManager.get_player_data().items[it.get_index()]
		#if item_data: Effector.add_hint_text(it,"item_"+item_data.code)

func _process(delta):
	if item_dropping_node:
		item_dropping_time += delta
		if item_dropping_time>.2: item_dropping_node.modulate.a = 1.2-item_dropping_time
		if item_dropping_time>0.8:
			on_drop_item(item_dropping_node.get_index(),item_dropping_node)
			stop_dropping_item()

func stop_dropping_item():
	if !item_dropping_time: return
	item_dropping_node.modulate.a = 1
	item_dropping_node = null
	item_dropping_time = 0

func update_player(data):
	for h in $HPContainer.get_children():
		if h.get_index() >= data.hpm: h.modulate.a = 0
		elif h.get_index() < data.hp: h.modulate.a = 1
		else: h.modulate.a = .3
	$Retrait/TextureRect.texture = load("res://assets/retraits/retrait"+str(data.retrait)+".jpg")
	$Label.text = "HP: "+str(data.hp)+" / "+str(data.hpm)+"\n"
	$Label.text += "MV: "+str(data.mv)+" / "+str(data.mvm)+"\n"
	$Label.text += "ROLLS: "+str(data.rl)+" / "+str(data.rlm)+"\n"
	fill_items(data)
	fill_dices(data)

func fill_items(data):
	for it in $Items.get_children():
		it.set_data(data.items[it.get_index()])

func fill_dices(data):
	for it in $Dices.get_children():
		var i = it.get_index()
		if i>=data.dices.size():
			it.get_node("TextureRect").texture = null
		else: 
			it.get_node("TextureRect").texture = load("res://assets/dices/AX.png")

func set_item_info(item_data):
	if !item_data:
		$ItemInfo.visible = false
	else:
		$ItemInfo/Label.text = item_data.name
		$ItemInfo/Image.texture = load("res://assets/items/"+item_data.ico+".png")
		$ItemInfo.visible = true

func on_click_down_item(item_index,it_node):
	var item_data = PlayerManager.get_player_data().items[item_index]
	if item_data: item_dropping_node = it_node

func on_click_up_item(item_index,it_node):
	if !item_dropping_node: return
	if item_dropping_time<0.2: on_use_item(item_index,it_node)
	stop_dropping_item()

func on_mouse_exited_item(item_index,it_node):
	stop_dropping_item()
	set_item_info(null)

func on_mouse_entered_item(item_index,it_node):
	stop_dropping_item()
	var item_data = PlayerManager.get_player_data().items[item_index]
	set_item_info(item_data)

func on_use_item(item_index,it_node):
	var item_data = PlayerManager.get_player_data().items[item_index]
	print("USE ITEM ",item_data)

func on_drop_item(item_index,it_node):
	print("DROP ITEM")
	stop_dropping_item()
	var pdata = PlayerManager.get_player_data()
	ItemManager.OBJECTS_IN_ROOM.add_item_to_room(pdata.items[item_index])
	pdata.items[item_index] = null
	fill_items(pdata)
	
