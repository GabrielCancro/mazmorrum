extends Control

var tile_pos = Vector2(3,3)
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.2),"timeout")
	update_minimap()

func update_minimap():
	for x in range(tile_pos.x-2,tile_pos.x+2+1):
		for y in range(tile_pos.y-2,tile_pos.y+2+1):
			update_miniroom(tile_pos.x+x,tile_pos.y+y)

func update_miniroom(x,y):
	print("MINIMAP UPDATE ",x,",",y)
	var data = MapManager.get_room_data(x,y)
	var node = $Grid.get_child( (y+2)*5 + (x+2) )
	if !data: node.modulate.a = 0
	else:
		if !data.is_explored: node.modulate.a = .5
		else: node.modulate.a = 1
	if x==0 && y==0: node.modulate = Color(.8,.8,1,1) 
