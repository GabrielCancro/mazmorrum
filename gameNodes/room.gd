extends Node2D

var data = {
	"is_explored":false,
	"type":"empty",
	"dif":8,
	"hp":2,
	"map_position":Vector2(),
	"tokens":[
		{"type":"trap"},
		{"type":"chest"}
	]
}

func _ready():
	generate_random_room()
	DataManager.data.rooms[name] = data
	update_room()
	visible = data.is_explored
	if int(data.map_position.x)%2==0: position.y -= 200
	z_index = -1000 + data.map_position.y*2 + int(data.map_position.x)%2
	modulate.a = 0
	$lbl_coord.text = str(data.map_position.x)+","+str(data.map_position.y)
	create_tokens()

func explore():
	if data.is_explored: return
	data.is_explored = true
	visible = data.is_explored
	Effector.appear(self)
	yield(get_tree().create_timer(.2),"timeout")
	for nt in $TokensContainer.get_children():
		yield(get_tree().create_timer(.2),"timeout")
		Effector.appear_from_up(nt)

func generate_random_room():
	randomize()
	var types = ["empty","trap","chest","enemy"]
	data.type = types[ randi()%types.size() ]
	data.type = "empty"
	data.dif = 5 + randi()%4
	
	data.tokens = []
	for i in range(randi()%3+1):
		data.tokens.append({"type":types[ randi()%types.size() ]})

func damage_enemy():
	DungeonManager.disable_input(.5)
	var pos_yoyo = DungeonManager.PLAYER_TOKEN.position.linear_interpolate(position, 0.5);
	Effector.move_yoyo(DungeonManager.PLAYER_TOKEN,pos_yoyo)
	yield(get_tree().create_timer(.5),"timeout")
	data.hp -= 1
	if data.hp <= 0:
		DungeonManager.move_player_to_room(self)
		DungeonManager.disable_input(.5)
		Effector.disappear($Enemy)
		yield(get_tree().create_timer(.5),"timeout")
		data.type = "empty"
		$Enemy.modulate.a = 1
	update_room()

func enemy_attack():
	DungeonManager.disable_input(.5)
	var pos_yoyo = (DungeonManager.PLAYER_TOKEN.position-position)*0.5;
	Effector.move_yoyo($Enemy,$Enemy.position+pos_yoyo)
	yield(get_tree().create_timer(.5),"timeout")
	DungeonManager.damage_player(1)

func update_room():
	hide_all_elements()
	if has_method("update_type_"+data.type): call("update_type_"+data.type)
	else:
		$Label.text = data.type.to_upper() + " " + str(data.dif)
		$Label.visible = true

func update_type_empty():
	pass

func update_type_enemy():
	$Enemy/Label.text = str(data.dif)
	$Enemy/Label2.text = ""
	for i in range(data.hp): $Enemy/Label2.text += "*"
	$Enemy.visible = true

func update_type_trap():
	$Trap/Label.text = str(data.dif)
	$Trap.visible = true
	
func hide_all_elements():
	$Label.visible = false
	$Enemy.visible = false
	$Trap.visible = false

func create_tokens():
	for nt in $TokensContainer.get_children():
		$TokensContainer.remove_child(nt)
		nt.queue_free()
	for t in data.tokens:
		var nt = preload("res://gameNodes/roomToken.tscn").instance()
		nt.data = t
		nt.modulate.a = 0
		$TokensContainer.add_child(nt)
