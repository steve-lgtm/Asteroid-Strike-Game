extends Node2D

onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")

func _on_Area2D_body_entered(body):
	queue_free()
	player.apples+=1
	print(player.apples)
