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

func map_room_out_fx(room,x,y):
	if !room: return
	var toX = MapManager.current_room.data.posX-x
	var toY = MapManager.current_room.data.posY-y
	Effector.disappear(room)
	Effector.move_to_rect_direction(room,Vector2(toX*100,toY*100))

func map_room_in_fx(room,x,y):
	if !room: return
	var toX = MapManager.last_room_coord.x-x
	var toY = MapManager.last_room_coord.y-y
	Effector.appear(room)
	room.rect_position -= Vector2(toX*100,toY*100)
	Effector.move_to_rect_direction(room,Vector2(toX*100,toY*100))

func set_shader_outline(node,color=null):
	node.material = null
	if color:
		node.material = preload("res://shaders/outline.tres").duplicate()
		(node.material as ShaderMaterial).set_shader_param("line_color",color)

func add_float_text(tx,ox,oy):
	var node = preload("res://gameNodes/effects/FloatText.tscn").instance()
	node.rect_position = Vector2(1280*ox, 720*oy)
	node.set_text(tx)
	DungeonManager.GAME.add_child(node)

func add_hint(node_area,node_showed):
	node_showed.visible = false
	node_area.connect("mouse_entered",self,"on_hint_action",[node_showed,true])
	node_area.connect("mouse_exited",self,"on_hint_action",[node_showed,false])

func on_hint_action(node,val):
	node.visible = val

var current_hint_text_node = null
var hint_text = preload("res://gameNodes/HintText.tscn").instance()
func add_hint_text(node,text_code):
	get_node("/GAME").add_child(hint_text)
	node.connect("mouse_entered",self,"on_hint_action",[node,text_code,true])
	node.connect("mouse_exited",self,"on_hint_action",[node,text_code,false])
	
func on_hint_text(node,txcode,val):
	if !val && current_hint_text_node==node: 
		hint_text.visible = false
		current_hint_text_node = null
	else:
		node.visible = true
