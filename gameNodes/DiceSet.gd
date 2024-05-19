extends Control

var results = []
var is_rolling = false
signal end_roll(results)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"roll_set")

func reset_set():
	results = []
	for d in $Dices.get_children(): d.reset()

func roll_set():
	PlayerManager.player_data_inc("mv",-99)
	if is_rolling: return
	is_rolling = true
	results = []
	for d in $Dices.get_children():
		if d.is_disabled(): continue
		d.roll()
	yield(get_tree().create_timer(1.2),"timeout")
	for d in $Dices.get_children():
		if !d.is_disabled(): results.append(d.value)
	#print("DICE SET ROLL: ",results)
	is_rolling = false
	emit_signal("end_roll",results)

func consume_dice(dice_node):
	if dice_node.is_disabled: return
	dice_node.set_disabled(true)
	results[dice_node.get_index()] = null
	print(results)

func restore_dice_by_type(dice_type):
	for d in $Dices.get_children():
		if d.value==dice_type && d.is_disabled():
			d.set_disabled(false)
			results[d.get_index()] = d.value
			return
	print(results)

func get_dice_nodes():
	return $Dices.get_children()
