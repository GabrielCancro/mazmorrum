extends Control

var is_rolling = false
signal end_roll

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"roll_set")

func reset_set():
	print("RESET DICES!!")
	Utils.remove_all_childs($Dices)
	for dice_type in PlayerManager.get_player_data().dices:
		var dice_node = preload("res://gameNodes/dice.tscn").instance()
		dice_node.type = dice_type
		$Dices.add_child(dice_node)
		dice_node.rect_position = Vector2(10+60 * dice_node.get_index(),10)

func roll_set():
	if !PlayerManager.player_data_inc("rl",-1): 
		Effector.add_float_text("wn_no_rolls",.5,.75)
		return
	PlayerManager.player_data_inc("mv",-99)
	DungeonManager.disable_input(1.3)
	if is_rolling: return
	is_rolling = true
	for d in $Dices.get_children():
		if d.is_disabled(): continue
		if d.in_slot: continue
		d.roll()
	yield(get_tree().create_timer(1.2),"timeout")
	is_rolling = false
	emit_signal("end_roll")
	

func get_dice_nodes():
	return $Dices.get_children()
