extends Node2D


onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")
onready var tree = get_node("Sprite")
var hp_left = 2


func _on_Hurtbox_area_entered(area):
	if player.apples == 2:
		tree.scale.x *= 0.75
		tree.scale.y *= 0.75
		hp_left -= 1
		if hp_left == 0:
			queue_free()
