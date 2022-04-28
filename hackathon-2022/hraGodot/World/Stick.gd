extends Node2D

onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")
onready var labelCountStick = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/StickCounter")



func _on_Area2D_body_entered(body):
	print(body)
	queue_free()
	player.sticks += 1
	labelCountStick.text = str(player.sticks)
