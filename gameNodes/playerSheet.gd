extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.connect("update_player_data",self,"update_player")
	for it in $Items.get_children(): 
		(it as Button).connect("button_down",self,"on_click_item",[it.get_index()])
		#var item_data = PlayerManager.get_player_data().items[it.get_index()]
		#if item_data: Effector.add_hint_text(it,"item_"+item_data.code)
	

func update_player(data):
	for h in $HBoxContainer.get_children():
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
		var i = it.get_index()
		if data.items[i] == null: 
			it.text = ""
			it.get_node("TextureRect").texture = null
		else: 
			it.text = data.items[i].name
			it.get_node("TextureRect").texture = load("res://assets/items/"+data.items[i].ico+".png")

func fill_dices(data):
	for it in $Dices.get_children():
		var i = it.get_index()
		if data.dices[i] == null:
			it.get_node("TextureRect").texture = null
		else: 
			it.get_node("TextureRect").texture = load("res://assets/dices/AX.png")
			
func on_click_item(item_index):
	var item_data = PlayerManager.get_player_data().items[item_index]
	print(item_index,"-",item_data)
