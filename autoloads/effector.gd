extends Node

onready var tween = Tween.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)


func move_to(node,pos):
	tween.interpolate_property(node,"position",node.position,pos,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func move_yoyo(node,pos):
	var start = node.position
	tween.interpolate_property(node,"position",start,pos,.2,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.interpolate_property(node,"position",pos,start,.2,Tween.TRANS_QUAD,Tween.EASE_OUT,.2)
	tween.start()
	

func appear(node):
	node.modulate.a = 0
	node.visible = true
	tween.interpolate_property(node,"modulate",Color(1,1,1,0),Color(1,1,1,1),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()

func disappear(node):
	tween.interpolate_property(node,"modulate",node.modulate,Color(1,1,1,0),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()
