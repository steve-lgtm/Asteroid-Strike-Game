extends Node2D


onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")
onready var countRock = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/RockCounter")
onready var rock = get_node("Sprite")
var hp_left = 2

func _ready():
	randomize()


func _on_Hurtbox_area_entered(area):
	print(area.name)
	if player.pickaxe == true:
		rock.scale.x *= 0.75
		rock.scale.y *= 0.75
		hp_left -= 1
		if hp_left == 0:
			player.rocks += randi() % 2 + 1
			countRock.text=str(player.rocks)
			queue_free()
