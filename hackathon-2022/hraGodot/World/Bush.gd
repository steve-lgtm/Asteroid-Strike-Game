extends StaticBody2D


onready var labelVar = $Label
onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player.craftingArea = true
		labelVar.visible = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player.craftingArea = false
		labelVar.visible = false
