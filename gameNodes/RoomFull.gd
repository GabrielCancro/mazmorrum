extends Control

var data

func _ready(): pass
	

func set_data(room_data):
	data = room_data

func create_tokens():
	print("CREATE TOKENS: ",data.tokens)
	for t in $Tokens.get_children():
		$Tokens.remove_child(t)
		t.queue_free()
	for token_data in data.tokens:
		var token_node = preload("res://gameNodes/tokenRoom.tscn").instance()
		token_data.room_ref = self
		token_node.set_data(token_data)
		$Tokens.add_child(token_node)
