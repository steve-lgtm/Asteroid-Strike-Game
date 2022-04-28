extends KinematicBody2D


const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

enum {
	MOVE,
	CHOP,
	ATTACK,
	MINE
}

var state = MOVE
var velocity = Vector2.ZERO
var stats = PlayerStats
var knockback = Vector2.ZERO

var apples = 0
var woods = 0
var rocks = 0
var smallRocks = 0
var sticks = 0
var asteroids = 0

# if tool is equipped
var axe = false
var sword = false
var pickaxe = false

var haveAxe = false
var haveSword = false
var havePickaxe = false

var craftingArea = false

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/Hitbox
onready var music = get_parent().get_parent().get_node("AudioStreamPlayer")
onready var craftingMenu = get_parent().get_parent().get_node("Crafting/CanvasLayer/TextureRect")

onready var countStick = get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/StickCounter")
onready var countSmallRock = get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/SmallRockCounter")
onready var countWood = get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/WoodCounter")
onready var countRock = get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/RockCounter")
onready var countAsteroid = get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/AsteroidCount")
onready var help = get_parent().get_parent().get_node("Help/CanvasLayer/Panel")

onready var pausePanel = get_parent().get_parent().get_node("Control/CanvasLayer/Panel")

onready var swordIcon = get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/Sword")
onready var axeIcon = get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/Axe")
onready var pickaxeIcon = get_parent().get_parent().get_node("HealthUI/CanvasLayer/Panel/Pickaxe")

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = Vector2.ZERO
	swordIcon.visible = true if haveSword else false
	axeIcon.visible = true if haveAxe else false
	pickaxeIcon.visible = true if havePickaxe else false

func _process(delta):
	if !craftingArea and craftingMenu.visible:
		craftingMenu.visible = false
	match state:
		MOVE:
			move_state(delta)
		
		CHOP:
			chop_state(delta)
		
		ATTACK:
			attack_state(delta)
		
		MINE:
			mine_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Chop/blend_position", input_vector)
		animationTree.set("parameters/Mine/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("next_item"):
		if sword:
			if haveAxe:
				axe = true
				axeIcon.modulate = Color(1,1,1)
				sword = false
				swordIcon.modulate = Color(0, 0, 0)
			elif havePickaxe:
				pickaxe = true
				pickaxeIcon.modulate = Color(1,1,1)
				sword = false
				swordIcon.modulate = Color(0, 0, 0)
		elif axe:
			if havePickaxe:
				pickaxe = true
				pickaxeIcon.modulate = Color(1,1,1)
				axe = false
				axeIcon.modulate = Color(0, 0, 0)
			elif haveSword:
				sword = true
				swordIcon.modulate = Color(1,1,1)
				axe = false
				axeIcon.modulate = Color(0, 0, 0)
		elif pickaxe:
			if haveSword:
				sword = true
				swordIcon.modulate = Color(1,1,1)
				pickaxe = false
				pickaxeIcon.modulate = Color(0, 0, 0)
			elif haveAxe:
				axe = true
				axeIcon.modulate = Color(1,1,1)
				pickaxe = false
				pickaxeIcon.modulate = Color(0, 0, 0)
		else:
			if sword:
				sword = true
			elif axe:
				axe = true
			elif pickaxe:
				pickaxe = true
	
	#ZOBRAZENIE CRAFTING MENU
	if Input.is_action_just_pressed("craft") and craftingArea:
		craftingMenu.visible = !craftingMenu.visible

	
	if Input.is_action_just_pressed("attack"):
		if axe and haveAxe:
			state = CHOP
		elif sword and haveSword:
			state = ATTACK
		elif pickaxe and havePickaxe:
			state = MINE

	if Input.is_action_just_pressed("pause"):
		pausePanel.visible = true


func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func chop_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Chop")

func mine_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Mine")

func attack_animation_finish():
	state = MOVE

func chop_animation_finish():
	state = MOVE

func mine_animation_finish():
	state = MOVE

func player_died():
	var PlayerDiedControl = get_parent().get_parent().get_node("PlayerDiedControl/CanvasLayer/Panel")
	PlayerDiedControl.visible = true
	queue_free()

# KNOCKBACK HRACA PO HITNUTI PRISEROU
func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	knockback = area.knockback_vector * 120
	velocity = velocity.move_toward(knockback, ACCELERATION * 0.25)
	move_and_slide(velocity)
	print(area.knockback_vector)
	print(knockback)
	if stats.health == 0:
		player_died()


func _on_CloseCrafting_pressed():
	craftingMenu.visible = false


func _on_CraftAxe_pressed():
	if sticks >= 10:
		sticks -= 10
		haveAxe = true
		axe = true
		pickaxe = false
		sword = false
		countStick.text=str(sticks)
		axeIcon.visible = true
		


func _on_CraftPickaxe_pressed():
	if woods >= 5 and rocks >= 5:
		rocks -= 5
		woods -= 5
		havePickaxe = true
		axe = false
		pickaxe = true
		sword = false
		countRock.text=str(rocks)
		countWood.text=str(woods)
		pickaxeIcon.visible = true


func _on_CraftSword_pressed():
	if woods >= 5 and asteroids >= 3:
		woods -= 5
		asteroids -= 3
		haveSword = true
		axe = false
		pickaxe = false
		sword = true
		countAsteroid.text=str(asteroids)
		countWood.text=str(woods)
		swordIcon.visible = true


func _on_Close_pressed():
	pausePanel.visible = false


func _on_QuitToMenu_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_AudioStreamPlayer_finished():
	music.play()


func _on_Button_pressed():
	help.visible = true


func _on_QuitHelp_pressed():
	help.visible = false
