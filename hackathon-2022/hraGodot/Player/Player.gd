extends KinematicBody2D


const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

enum {
	MOVE,
	CHOP,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

var apples = 0
var woods = 0
var axe = false
var sword = true

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/Hitbox

func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = Vector2.ZERO

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		CHOP:
			chop_state(delta)
		
		ATTACK:
			attack_state(delta)

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
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("next_item"):
		sword = !sword
		axe = !axe
	
	if Input.is_action_just_pressed("attack"):
		# PO ZOBRATI JABLKA SA ANIMACIA PREPNE NA SEKERKU
		if axe == true:
			state = CHOP
		elif sword == true:
			state = ATTACK


func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func chop_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Chop")

func attack_animation_finish():
	state = MOVE

func chop_animation_finish():
	state = MOVE
