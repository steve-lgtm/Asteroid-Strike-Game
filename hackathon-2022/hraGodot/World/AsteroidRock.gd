extends Node2D


onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")
onready var countAsteroids = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/AsteroidCount")
onready var asteroid = get_node("Sprite")
var hp_left = 2

func _ready():
	randomize()

func _on_Hurtbox_area_entered(area):
	if player.pickaxe == true:
		asteroid.scale.x *= 0.75
		asteroid.scale.y *= 0.75
		hp_left -= 1
		if hp_left == 0:
			player.asteroids += 1
			countAsteroids.text=str(player.asteroids)
			queue_free()
