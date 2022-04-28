extends Control

var hearts = 5
var max_hearts = 5

onready var label = $CanvasLayer/Panel/LifeCounter

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if label != null:
		label.text = str(hearts)

func set_max_hearts(value):
	max_hearts = max(value, 1)

func _ready():
	PlayerStats.max_health = self.max_hearts
	PlayerStats.health = self.max_hearts

func _process(delta):
	set_hearts(PlayerStats.health)
