extends Control

var is_rolling = false
signal end_roll

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"roll_set")

func reset_set():
	for d in $Dices.get_children(): d.reset()

func roll_set():
	if !PlayerManager.player_data_inc("rl",-1): return
	PlayerManager.player_data_inc("mv",-99)
	DungeonManager.disable_input(1.3)
	if is_rolling: return
	is_rolling = true
	for d in $Dices.get_children():
		if d.is_disabled(): continue
		d.roll()
	yield(get_tree().create_timer(1.2),"timeout")
	is_rolling = false
	emit_signal("end_roll")

func get_dice_nodes():
	return $Dices.get_children()
