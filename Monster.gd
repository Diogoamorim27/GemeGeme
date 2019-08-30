extends KinematicBody2D

enum states {SENTINEL, CHASE, DEATH}

const RUNNING_SPEED = 200
const AIR_SPEED = 120
const GRAVITY = WorldConstants.GRAVITY

var state
var movement : = Vector2()

func _ready():
	pass 

func _process(delta):
	match state:
		states.SENTINEL:
			pass
		states.CHASE:
			pass
		states.DEATH:
			pass

func _apply_movement(input : int, speed : float) -> void:
	movement.x = input * speed
	
func _apply_gravity(delta) -> void:
	movement.y += GRAVITY * delta