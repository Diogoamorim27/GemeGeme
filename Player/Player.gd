extends KinematicBody2D

enum states {RUN, JUMP, DEATH, IDLE, SWIM}

const RUNNING_SPEED = 200
const AIR_SPEED = 120
const GRAVITY = WorldConstants.GRAVITY
const JUMP = -55 * 5
const WATER_FALL_SPEED = 100
const SWIM_SPEED = 100
const SWIM_UP = -130
const WATER_GRAVITY = WorldConstants.GRAVITY * 0.6

var balance = 0
var movement : = Vector2()
var state
var enable_swim = true
onready var breath_timer = get_node("Timer_Breath")
var breath
var start_time
var current_time
#var punching = false

func _ready():
	state = states.RUN
	pass # Replace with function body.

func _process(delta):
	#if Input.is_action_just_pressed("punch"):
	#	punching = true
	#	pass
	var input = _get_input_direction()
	match state:
		states.RUN:
			_apply_movement(input, RUNNING_SPEED)
			
			if is_on_floor():
				if input == 0:
					state = states.IDLE
				elif Input.is_action_pressed("ui_up"):
					_jump(JUMP)
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
					_jump(JUMP)
			else:
				state = states.JUMP
				
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)	
		states.SWIM:
			current_time = OS.get_unix_time()
			breath = $Timer_Breath.wait_time - ((current_time - start_time) % 60)
			print(breath)
			_sink(delta)
			_apply_movement(input, SWIM_SPEED)
			if enable_swim and Input.is_action_pressed("ui_up"):
				_jump(SWIM_UP)
				enable_swim = false
			
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
	
func _sink(delta) -> void:
	if movement.y < WATER_FALL_SPEED:
		movement.y += WATER_GRAVITY * delta
	else:
		movement.y = WATER_FALL_SPEED
	
func _jump(jump_speed: float) -> void:
	movement.y = jump_speed
	pass



func _on_Water_body_entered(body):
	state = states.SWIM
	breath_timer.start()
	breath = $Timer_Breath.wait_time
	start_time = OS.get_unix_time()

func _on_Water_body_exited(body):
	state = states.IDLE


func _on_Timer_Swim_timeout():
	enable_swim = true


func _on_Timer_Breath_timeout():
	state = states.DEATH