extends Node2D


var hp_left = 2


func _on_Hurtbox_area_entered(area):
	hp_left = hp_left - 1
	if hp_left == 0:
		queue_free()
