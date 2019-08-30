extends KinematicBody2D

enum states {RUN, JUMP, DEATH, IDLE}

const RUNNING_SPEED = 200
const AIR_SPEED = 120
const GRAVITY = WorldConstants.GRAVITY
const JUMP = -55 * 5

var balance = 0
var movement : = Vector2()
var state

func _ready():
	state = states.RUN
	pass # Replace with function body.

func _process(delta):
	var input = _get_input_direction()
	match state:
		states.RUN:
			_apply_movement(input, RUNNING_SPEED)
			
			if is_on_floor():
				if input == 0:
					state = states.IDLE
				elif Input.is_action_pressed("ui_up"):
					_jump()
			else:
				state = states.JUMP
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
		
		states.JUMP:
			_apply_gravity(delta)
			_apply_movement(input, AIR_SPEED)
			
			if is_on_floor():
				if input == 0:
					state = states.IDLE
				else:
					state = states.RUN
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
		
		states.DEATH:
			_apply_movement(0, 0)
			_apply_gravity(delta)
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
		
		states.IDLE:
			if is_on_floor():
				if input != 0:
					state = states.RUN
				if Input.is_action_pressed("ui_up"):
					_jump()
			else:
				state = states.JUMP
				
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)	

func _get_input_direction() -> int:
	if !(Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
		balance = 0
		return 0

	if Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
		balance = 1
		return 1

	if !Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		balance = -1
		return -1

	if balance == 1 and Input.is_action_pressed("ui_left"):
		return -1

	if balance == -1 and Input.is_action_pressed("ui_right"):
		return 1

	return 0
	
func _apply_movement(input : int, speed : float) -> void:
	movement.x = input * speed
	
func _apply_gravity(delta) -> void:
	movement.y += GRAVITY * delta
	
func _jump() -> void:
	movement.y = JUMP
	pass
