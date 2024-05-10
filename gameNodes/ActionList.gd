extends Control

var tokens = []

# Called when the node enters the scene tree for the first time.
func _ready():
	DungeonManager.connect("room_changed",self,"fill_action_list")

func fill_action_list():
	visible = false
	for ac in $VBox.get_children():
		$VBox.remove_child(ac)
		ac.queue_free()
	yield(get_tree().create_timer(.2),"timeout")
	tokens = MapManager.current_room.data.tokens
	for tk in tokens:
		var action_line = load("res://gameNodes/ActionLine.tscn").instance()
		action_line.set_token_data(tk)
		$VBox.add_child(action_line)
	yield(get_tree().create_timer(.1),"timeout")
	Effector.appear(self)
	visible = true


func on_hint_action(btn,tk,val):
	if val: 
		btn.modulate.b = .5
		if tk: tk.token_ref.modulate.b = .5
	else: 
		btn.modulate.b = 1
		if tk: tk.token_ref.modulate.b = 1


