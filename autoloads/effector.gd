extends Node

onready var tween = Tween.new()
var GAME

# Called when the node enters the scene tree for the first time.
func _initialize_effector(SCENE):
	GAME = SCENE
	add_child(tween)
	GAME.get_node("HintText").visible = false

func _process(delta):
	if GAME.get_node_or_null("HintText") && GAME.get_node("HintText").visible:
		GAME.get_node("HintText").rect_global_position = get_viewport().get_mouse_position() + Vector2(10,20)

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

func from_scale(node):
	tween.interpolate_property(node,"rect_scale",Vector2(1.2,1.2),Vector2(1,1),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()

func from_color(node,color):
	tween.interpolate_property(node,"modulate",color,Color(1,1,1,1),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
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

func add_float_text(txcode,ox,oy):
	var node = preload("res://gameNodes/effects/FloatText.tscn").instance()
	node.rect_position = Vector2(1280*ox, 720*oy)
	node.set_text(Lang.get_string(txcode))
	DungeonManager.GAME.add_child(node)

func add_hint(node_area,node_showed):
	node_showed.visible = false
	node_area.connect("mouse_entered",self,"on_hint_action",[node_showed,true])
	node_area.connect("mouse_exited",self,"on_hint_action",[node_showed,false])

func on_hint_action(node,val):
	node.visible = val

var current_hint_text_node
func add_hint_text(node,text_code):
	node.connect("mouse_entered",self,"on_hint_text",[node,text_code,true])
	node.connect("mouse_exited",self,"on_hint_text",[node,text_code,false])
	
func on_hint_text(node,txcode,val):
	if !val && current_hint_text_node==node: 
		GAME.get_node("HintText").visible = false
		current_hint_text_node = null
	else:
		current_hint_text_node = node
		GAME.get_node("HintText/Label").text = Lang.get_string(txcode)
		GAME.get_node("HintText").visible = true

func resalt_card(node):
	if !is_instance_valid(node): return
	tween.interpolate_property(node,"rect_scale",node.rect_scale,Vector2(1.2,1.2),.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.interpolate_property(node,"modulate",node.modulate,Color(1,1,0,1),.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func unresalt_card(node):
	if !is_instance_valid(node): return
	tween.interpolate_property(node,"rect_scale",node.rect_scale,Vector2(1,1),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.interpolate_property(node,"modulate",node.modulate,Color(1,1,1,1),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()

func shake(node,power=2,time=.5):
	var ini_pos = node.rect_position
	randomize()
	while time>0:
		if !is_instance_valid(node): return
		node.rect_position = ini_pos + Vector2(rand_range(-power,power),rand_range(-power/2,power/2))
		time -= .025
		yield(get_tree().create_timer(.025),"timeout")
	node.rect_position = ini_pos
