extends KinematicBody2D

enum states {SENTINEL, CHASE, DEATH}

const RUNNING_SPEED = 100
const AIR_SPEED = 120
const GRAVITY = 9.8 * 50
const RAYCAST_CAST_TO = 10000
const WALL_CAST_TO = 50

onready var sprite : = $Sprite
onready var timer : = $PatrolTimer
onready var raycast : = $RayCastPatrol
onready var raycast_wall : = $RaycastWall

export var health = 3

var state = states.SENTINEL
var movement : = Vector2()
var sentinel_direction : = 1

func _ready():
	pass
#	


func _process(delta):
#	print(movement)
#	print(state)

	if movement.x > 0:
		raycast_wall.cast_to.x = WALL_CAST_TO
		sprite.flip_h = false
	if movement.x < 0:
		raycast_wall.cast_to.x = -WALL_CAST_TO
		sprite.flip_h = true

	match state:
		states.SENTINEL:
			_apply_movement(sentinel_direction, RUNNING_SPEED)

					
			if raycast_wall.is_colliding():
				sentinel_direction *= -1
				raycast_wall.cast_to.x *= -1
				print (raycast_wall.cast_to.x)
				timer.start()
				

	_handle_animation()
	if !is_on_floor():
		_apply_gravity(delta)
		
	movement = move_and_slide(movement, Vector2.UP)
#	print(movement)
	
func _apply_movement(input : int, speed : float) -> void:
	movement.x = input * speed
	
func _apply_gravity(delta) -> void:
	movement.y += GRAVITY * delta
	
func _handle_animation():
	if movement.x > 0:
		raycast.cast_to.x = RAYCAST_CAST_TO
#		raycast_wall.cast_to.x = WALL_CAST_TO
	if movement.x < 0:
		raycast.cast_to.x = -RAYCAST_CAST_TO
		raycast_wall.cast_to.x = -WALL_CAST_TO




func _on_PatrolTimer_timeout():
	sentinel_direction *= -1
	pass # Replace with function body.
