extends Node2D

onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")
onready var labelCountSmallRock = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/SmallRockCounter")



func _on_Area2D_body_entered(body):
	print(body)
	queue_free()
	player.smallRocks += 1
	labelCountSmallRock.text = str(player.smallRocks)
