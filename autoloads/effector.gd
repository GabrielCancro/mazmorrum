extends Node

onready var tween = Tween.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)


func move_to(node,pos):
	tween.interpolate_property(node,"position",node.position,pos,.3,Tween.TRANS_EXPO,Tween.EASE_OUT)
	tween.start()

func appear(node):
	node.modulate.a = 0
	tween.interpolate_property(node,"modulate",Color(1,1,1,0),Color(1,1,1,1),.3,Tween.TRANS_EXPO,Tween.EASE_IN)
	tween.start()
