extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	DungeonManager._initialize_dungeon_manager(self)

func _input(ev):
	var dir = Vector2()
	if Input.is_action_just_pressed("ui_right"): dir.x = 1
	if Input.is_action_just_pressed("ui_left"): dir.x = -1
	if Input.is_action_just_pressed("ui_up"): dir.y = -1
	if Input.is_action_just_pressed("ui_down"): dir.y = 1
	
	if dir.length()!=0: DungeonManager.move_player(dir)
