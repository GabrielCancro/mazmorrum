extends Node2D

var map_position = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.1),"timeout")
	DungeonManager.MAP.try_explore_room(map_position.x,map_position.y)
	DungeonManager.move_player(map_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
