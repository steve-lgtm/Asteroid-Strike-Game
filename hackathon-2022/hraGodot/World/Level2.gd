extends Node2D


onready var level2win = get_parent().get_parent().get_node("Control2/CanvasLayer/Panel")




func _on_LEVEL2button_pressed():
	level2win.visible = false
	queue_free()


func _on_LEVEL2AREA_body_entered(body):
	if body.name == "Player":
		level2win.visible = true

