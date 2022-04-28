extends Node2D


onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")
onready var countRock = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/RockCounter")
onready var countWood = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/WoodCounter")
onready var countSmallRock = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/SmallRockCounter")
onready var countStick = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/StickCounter")
onready var box = get_node("Sprite")
var hp_left = 2
var rng = RandomNumberGenerator.new()



func _on_Hurtbox_area_entered(area):
	if player.axe == true:
		box.scale.x *= 0.75
		box.scale.y *= 0.75
		hp_left -= 1
		if hp_left == 0:
			queue_free()
			rng.randomize()
			var number = rng.randi_range(1, 18)
			print(number)
			if number <= 4:
				player.smallRocks += rng.randi_range(1, 3)
				countSmallRock.text = str(player.smallRocks)
			elif number <= 8:
				player.sticks += rng.randi_range(1, 3)
				countStick.text = str(player.sticks)
			elif number <= 10:
				player.woods += rng.randi_range(1, 2)
				countWood.text = str(player.woods)
			elif number <= 12:
				player.rocks += rng.randi_range(1, 2)
				countRock.text = str(player.rocks)
