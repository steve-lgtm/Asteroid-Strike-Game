extends Node2D

onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")
var hp_left = 2


func _on_Hurtbox_area_entered(area):
	if player.apples == 2:
		hp_left = hp_left - 1
		if hp_left == 0:
			queue_free()
	else:
		print("player.axe")
