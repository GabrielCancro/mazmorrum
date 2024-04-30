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
	modulate.a = 0

func explore():
	if data.is_explored: return
	data.is_explored = true
	visible = data.is_explored
	Effector.appear(self)

func generate_random_room():
	randomize()
	var types = ["empty","trap","chest","enemy"]
	data.type = types[ randi()%types.size() ]
	data.dif = 5 + randi()%4

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

