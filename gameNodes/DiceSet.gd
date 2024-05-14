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

func consume_dice(dice):
	for d in $Dices.get_children():
		if d.value==dice && !d.is_disabled():
			d.set_disabled(true)
			results.erase(dice)
			return
	print(results)

func restore_dice(dice):
	for d in $Dices.get_children():
		if d.value==dice && d.is_disabled():
			d.set_disabled(false)
			results.append(dice)
			return
	print(results)
