extends Control

var results
var is_rolling = false
signal end_roll

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"roll_set")

func roll_set():
	if is_rolling: return
	is_rolling = true
	results = []
	for d in $Dices.get_children():
		d.roll()
	yield(get_tree().create_timer(1.2),"timeout")
	for d in $Dices.get_children():
		results.append(d.value)
	print("DICE SET ROLL: ",results)
	is_rolling = false
	emit_signal("end_roll")
