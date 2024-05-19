extends Node

var items = {
	"sword1":{"name":"sword","type":"equip","ico":"sword","dices":["SW"]},
	"shield1":{"name":"shield","type":"equip","ico":"shield","dices":["SW"]},
	"potion1":{"name":"potion","type":"use","ico":"potion","dices":["SW"]},
}

func get_item_data(item_code):
	var it = items[item_code].duplicate()
	it["code"] = item_code
	if it["type"]=="equip": it["equipped"] = false
	return it
