extends StaticBody2D


onready var labelVar = $Label

onready var bridgeWin = get_parent().get_parent().get_node("BridgeBuild/CanvasLayer/Panel")
onready var player = get_parent().get_parent().get_node("YSort/Player")
var buildArea = false


signal changeTiles


func _process(delta):
	if Input.is_action_just_pressed("use") and buildArea:
		if player.rocks == 5 and player.woods == 10:
			player.rocks -= 5
			player.woods -= 10
			player.countRock.text=str(player.rocks)
			player.countWood.text=str(player.woods)
			emit_signal("changeTiles")
			queue_free()
		else:
			bridgeWin.visible = true

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		labelVar.visible = true
		buildArea = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		labelVar.visible = false
		buildArea = false
	
