extends Node

var OBJECTS_IN_ROOM

var items = {
	"sword1":{"name":"sword","type":"equip","ico":"sword","dices":["SW"]},
	"shield1":{"name":"shield","type":"equip","ico":"shield","dices":["SW"]},
	"potion1":{"name":"potion","type":"use","ico":"potion","dices":["SW"]},
}

func get_item_data(item_code):
	var it = items[item_code].duplicate(true)
	it["code"] = item_code
	if it["type"]=="equip": it["equipped"] = false
	return it

func get_some_items():
	randomize()
	var rn_items = []
	for i in range(randi()%4):
		var rn_code = items.keys()[ randi()%items.keys().size() ]
		rn_items.append( get_item_data(rn_code) )
	return rn_items
