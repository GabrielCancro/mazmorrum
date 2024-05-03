extends Control
class_name PlayerToken

var map_position = Vector2(0,0)
var original_dices_font_color = Color("767c39")
signal on_dices(result)

# Called when the node enters the scene tree for the first time.
func _ready():
	$lb_dices.visible = false
	#yield(get_tree().create_timer(.1),"timeout")
	#DungeonManager.MAP.try_explore_room(map_position.x,map_position.y)

func run_dices(opt={}):
	randomize()
	DungeonManager.disable_input(20*.05+.5+1)
	$lb_dices.add_color_override("font_color", original_dices_font_color)
	var d1
	var d2
	Effector.appear($lb_dices)
	for i in range(20):
		d1 = randi()%6+1
		d2 = randi()%6+1
		$lb_dices.text = str(d1)+"+"+str(d2)
		yield(get_tree().create_timer(.05),"timeout")
	yield(get_tree().create_timer(.5),"timeout")
	
	Effector.appear($lb_dices)
	$lb_dices.text = str(d1+d2)
	if "dif" in opt: 
		if d1+d2>=opt.dif: $lb_dices.add_color_override("font_color", Color("e8ff00"))
		else: $lb_dices.add_color_override("font_color", Color("620000"))
	
	yield(get_tree().create_timer(1),"timeout")
	$lb_dices.visible = false
	emit_signal("on_dices",d1+d2)
