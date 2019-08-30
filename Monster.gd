extends KinematicBody2D

enum states {SENTINEL, CHASE, DEATH}

const RUNNING_SPEED = 300
const AIR_SPEED = 120
const GRAVITY = WorldConstants.GRAVITY
const RAYCAST_CAST_TO = 10000

onready var sprite : = $Sprite
onready var timer_left : = $TimerLeft
onready var timer_right : = $TimerRight
onready var raycast : = $RayCast2D

var state = states.SENTINEL
var movement : = Vector2()
var sentinel_direction : = 1

func _ready():
	pass
#	


func _process(delta):
	match state:
		states.SENTINEL:
			_apply_movement(sentinel_direction, RUNNING_SPEED)
			if raycast.get_collider():
				print("hi")
				if raycast.get_collider().name == "Player":
					print("henlo")
					state = states.CHASE
					timer_left.stop()
					timer_right.stop()
		states.CHASE:
			if !raycast.get_collider():
				state = states.SENTINEL
				timer_right.start()
			elif raycast.get_collider().name != "Player":
				state = states.SENTINEL
				timer_right.start()
			pass
		states.DEATH:
			pass
			
	_handle_animation()
	if !is_on_floor():
		_apply_gravity(delta)
	movement = move_and_slide(movement, Vector2.UP)
	
func _apply_movement(input : int, speed : float) -> void:
	movement.x = input * speed
	
func _apply_gravity(delta) -> void:
	movement.y += GRAVITY * delta
	
func _handle_animation():
	if movement.x > 0:
		raycast.cast_to.x = RAYCAST_CAST_TO
	if movement.x < 0:
		raycast.cast_to.x = -RAYCAST_CAST_TO



func _on_TimerLeft_timeout():
	sentinel_direction = 1
	pass # Replace with function body.


func _on_TimerRight_timeout():
	sentinel_direction = -1
	pass # Replace with function body.
