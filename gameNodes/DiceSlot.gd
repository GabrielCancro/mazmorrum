extends Control

var have_dice
export var req = "SW"

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = load("res://assets/dices/"+req+".png")

func _process(delta):
	if DiceManager.dice_sellected:
		if check_dice():
			DiceManager.dice_sellected.rect_global_position = rect_global_position
			modulate = Color(1,1,0,1)
			DiceManager.slot_in_area = self
		else:
			modulate = Color(1,1,1,1)
			if DiceManager.slot_in_area==self: DiceManager.slot_in_area = null
	if have_dice: modulate = Color(1,1,0,1)

func check_dice():
	var result = true
	result = result && DiceManager.dice_sellected.rect_global_position.distance_to(rect_global_position)<25
	result = result && DiceManager.dice_sellected.value==req
	result = result && !have_dice
	return result
