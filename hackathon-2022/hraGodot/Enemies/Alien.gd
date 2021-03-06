extends KinematicBody2D

export var ACCELERATION = 150
export var MAX_SPEED = 20
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE
var direction = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var swordHitbox = $Hitbox
onready var player = get_parent().get_parent().get_node("YSort/Player")

func _ready():
	swordHitbox.knockback_vector = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				swordHitbox.knockback_vector = (direction * MAX_SPEED).normalized()
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0	
			
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

	
func _on_Hurtbox_area_entered(area):
	if player.sword == true:
		stats.health -= 1
		if stats.health <= 0:
			player.aliensKilled += 1
			queue_free()
	knockback = area.knockback_vector * 120
	
