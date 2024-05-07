extends Node

onready var tween = Tween.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)


func move_to(node,pos):
	tween.interpolate_property(node,"position",node.position,pos,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func move_to_rect_direction(node,dir):
	tween.interpolate_property(node,"rect_global_position",node.rect_global_position,node.rect_global_position+dir,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
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

func appear_from_up(node):
	node.modulate.a = 0
	node.visible = true
	var end = node.rect_position
	tween.interpolate_property(node,"rect_position",end-Vector2(0,20),end,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.interpolate_property(node,"modulate",Color(1,1,1,0),Color(1,1,1,1),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()

func disappear(node):
	tween.interpolate_property(node,"modulate",node.modulate,Color(1,1,1,0),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()

