extends Node2D


onready var player = get_parent().get_parent().get_parent().get_node("YSort/Player")
onready var countRock = get_parent().get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/RockCounter")
onready var box = get_node("Sprite")
var hp_left = 2
var rng = RandomNumberGenerator.new()



func _on_Hurtbox_area_entered(area):
	if player.axe == true:
		box.scale.x *= 0.75
		box.scale.y *= 0.75
		hp_left -= 1
		if hp_left == 0:
			#player.rocks+=1
			#countRock.text=str(player.rocks)
			queue_free()
			rng.randomize()
			var number = rng.randi_range(1, 10)
			print(number)
			if number > 2:
				player.rocks+=1
				countRock.text=str(player.rocks)
			
