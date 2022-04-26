extends Node2D

onready var stuff = get_parent().get_parent().get_parent().get_node("YSort/Player")

func _on_Area2D_body_entered(body):
	queue_free()
	stuff.apples+=1
