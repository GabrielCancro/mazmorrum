extends Node2D

var data = {
	"is_explored":false,
	"type":"empty",
	"dif":8,
	"map_position":Vector2()
}

func _ready():
	generate_random_room()
	DataManager.data.rooms[name] = data
	$Label.text = data.type.to_upper() + " " + str(data.dif)
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
	data.dif = 6 + randi()%5
