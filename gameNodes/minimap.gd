extends Control

var tile_pos = Vector2(3,3)
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.2),"timeout")
	update_minimap()

func update_minimap():
	for node_x in range(-2,3):
		for node_y in range(-2,3):
			update_miniroom(node_x,node_y)

func update_miniroom(node_x,node_y):
	#print("MINIMAP UPDATE ",node_x,",",node_y)
	var data = MapManager.get_room_data(tile_pos.x+node_x,tile_pos.y+node_y)
	var node = $Grid.get_child( (node_y+2)*5 + (node_x+2) )
	if !data: node.modulate.a = 0
	else:
		if !data.is_explored: node.modulate.a = .5
		else: node.modulate.a = 1
	if node_x==0 && node_y==0: node.modulate = Color(.8,.8,1,1) 