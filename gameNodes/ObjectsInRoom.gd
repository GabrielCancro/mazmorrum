extends Control

func _ready():
	ItemManager.OBJECTS_IN_ROOM = self

func load_room_items():
	Utils.remove_all_childs($VBoxContainer)
	for it_data in MapManager.current_room.data.items:
		var it_node = load("res://gameNodes/ItemObject.tscn").instance()
		it_node.set_data(it_data)
		(it_node as Button).connect("button_down",self,"on_click_item",[it_node,it_data])
		$VBoxContainer.add_child(it_node)

func on_click_item(it_node,it_data):
	if PlayerManager.add_item_to_player(it_data):
		MapManager.current_room.data.items.erase(it_data)
		load_room_items()

func add_item_to_room(it_data):
	MapManager.current_room.data.items.append(it_data)
	load_room_items()
