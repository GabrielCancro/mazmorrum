extends Control

var tile_pos = Vector2(3,3)
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.2),"timeout")
	update_minimap()

func update_minimap():
	tile_pos.x = MapManager.current_room.data.posX
	tile_pos.y = MapManager.current_room.data.posY
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
		elif data.state=="ask": node.modulate = Color(.2,.15,.15,1)
		else: node.modulate = Color(.5,.5,.5,1)
	if node_x==0 && node_y==0: node.modulate = Color(.8,.8,.3,1)
