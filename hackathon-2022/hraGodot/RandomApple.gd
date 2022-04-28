extends Node2D


var apple = preload("res://World/Apple.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var randomuj = apple.instance()
	randomuj.position = Vector2(rand_range(300,0),rand_range(300,0))
	add_child(randomuj)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
