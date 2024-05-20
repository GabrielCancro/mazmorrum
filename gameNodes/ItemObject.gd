extends Button

var item_data

func set_data(_item_data):
	item_data = _item_data
	if item_data:
		$TextureRect.texture = load("res://assets/items/"+item_data.ico+".png")
	else:
		$TextureRect.texture = null
