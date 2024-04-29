extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	DungeonManager.connect("update_player_data",self,"update_player")

func update_player(data):
	for h in $HBoxContainer.get_children():
		if h.get_index() < data.hp: h.modulate.a = 1
		else: h.modulate.a = .3
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
