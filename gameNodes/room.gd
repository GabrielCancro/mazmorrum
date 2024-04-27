extends Node2D

var is_explored = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = is_explored
	modulate.a = 0

func explore():
	if is_explored: return
	is_explored = true
	visible = is_explored
	Effector.appear(self)
