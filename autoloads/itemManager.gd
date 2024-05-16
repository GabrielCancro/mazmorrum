extends Node

var items = {
	"sword1":{"name":"sword","type":"equip","dices":["SW"]}
}

func get_item_data(item_code):
	var it = items[item_code].duplicate()
	it["code"] = item_code
	it["equipped"] = false
	return it
