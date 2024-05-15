extends Control

var tile_pos = Vector2(3,3)
# Called when the node enters the scene tree for the first time.
func _ready():
	MapManager.connect("load_new_room",self,"update_minimap")
	yield(get_tree().create_timer(.2),"timeout")

func update_minimap(room_data):
	tile_pos.x = room_data.posX
	tile_pos.y = room_data.posY
	for node_x in range(-2,3):
		for node_y in range(-2,3):
			update_miniroom(node_x,node_y)

func update_miniroom(node_x,node_y):
	#print("MINIMAP UPDATE ",node_x,",",node_y)
	var data = MapManager.get_room_data(tile_pos.x+node_x,tile_pos.y+node_y)
	var node = $Grid.get_child( (node_y+2)*5 + (node_x+2) )
	if !data: node.modulate.a = 0
	else:
		node.modulate = Color(1,1,1,1)
		if data.state=="unexplored": node.modulate =  Color(0,0,0,0)
		elif data.state=="ask": 
			node.get_node("up").visible = false
			node.get_node("down").visible = false
			node.get_node("left").visible = false
			node.get_node("right").visible = false
			node.modulate = Color(.2,.10,.10,0)
		else: 
			node.get_node("up").visible = data.doors.up
			node.get_node("down").visible = data.doors.down
			node.get_node("left").visible = data.doors.left
			node.get_node("right").visible = data.doors.right
			node.modulate = Color(.5,.5,.5,1)
	if node_x==0 && node_y==0: node.modulate = Color(.8,.8,.3,1)
