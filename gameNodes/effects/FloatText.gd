extends Control

func _ready():
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),1.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.interpolate_property(self,"rect_scale",Vector2(1,1),Vector2(1.3,1.3),.75,Tween.TRANS_QUAD,Tween.EASE_IN,.75)
	$Tween.start()
	yield($Tween,"tween_completed")
	queue_free()

func set_text(tx):
	$Label.text = tx
