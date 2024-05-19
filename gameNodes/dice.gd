extends Control

var index = 0
var type = "basic"
var value = ""
var start_pos
var is_disabled

func _ready():
	start_pos = rect_global_position
	reset()

func roll():
	var faces = DiceManager.get_dice_faces(type)
	for i in range(10):
		$Label.text = "??"
		$TextureRect.texture = null
		index = randi()%faces.size() 
		value = faces[index]
		if value: $TextureRect.texture = load("res://assets/dices/"+value+".png")
		else: $TextureRect.texture = null
		rect_rotation = rand_range(-10,10)
		yield(get_tree().create_timer(.1),"timeout")
	$Label.text = value
	if value: $TextureRect.texture = load("res://assets/dices/"+value+".png")
	else: $TextureRect.texture = null
	rect_rotation = 0

func reset():
	$TextureRect.texture = null
	value = ""
	rect_rotation = 0
	set_disabled(false)

func set_disabled(val):
	is_disabled = val
	if is_disabled: modulate.a = .5
	else: modulate.a = 1

func is_disabled():
	return is_disabled
