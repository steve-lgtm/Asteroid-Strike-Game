extends StaticBody2D


onready var labelVar = $Label
onready var player = get_parent().get_parent().get_node("YSort/Player")
var buildArea = false


signal changeTiles


func _process(delta):
	if Input.is_action_just_pressed("use") and buildArea and player.rocks == 5 and player.woods == 10:
		emit_signal("changeTiles")
		queue_free()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		labelVar.visible = true
		buildArea = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		labelVar.visible = false
		buildArea = false
	
