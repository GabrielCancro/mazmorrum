extends Node

var data = {
	"players":[
		{"hp":6,"hpm":6,"mv":3,"mvm":3,"fue":0,"agi":2,"int":2,"eq1":null,"eq2":null,"itmes":[],"skills":[]}
	],
	"rooms":{}
}

func _ready():
	pass # Replace with function body.

func get_current_player_data():
	return data.players[DungeonManager.current_player_index]

func get_room_data(x,y):
	return data.rooms["room_"+str(x)+"_"+str(y)]
