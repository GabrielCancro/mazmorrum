extends Control

var data = {"type":"trap"}

signal end_animation
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"reveal_token")

func reveal_token():
	$Tween.interpolate_property(self,"rect_scale",Vector2(1,1),Vector2(.1,1),.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
	yield($Tween,"tween_completed")
	$TextureRect.texture = preload("res://assets/money_m.png")
	$Label.text = data.type
	$Tween.remove_all()
	$Tween.interpolate_property(self,"rect_scale",Vector2(.1,1),Vector2(1,1),.3,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	yield($Tween,"tween_completed")
	emit_signal("end_animation")
