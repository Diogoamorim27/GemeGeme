extends KinematicBody2D

enum states {RUN, JUMP, DEATH, IDLE, SWIM, CLIMB, INTERACTING}

const RUNNING_SPEED = 200
const AIR_SPEED = 120
const GRAVITY = 9.8 * 50
const JUMP = -55 * 3
const BOOT_JUMP = -50 * 2
const WATER_FALL_SPEED = 100
const SWIM_SPEED = 110
const SWIM_UP = -130
const WATER_GRAVITY = GRAVITY * 0.6
const CLIMB_SPEED = 100

var balance = 0
var movement : = Vector2()
var state
var enable_swim = true
onready var breath_timer = get_node("Timer_Breath")
onready var punch_timer = get_node("Punch_Area/CollisionShape2D/Punch_Timer")
var breath 
var start_time = 0
var current_time = 0
var jump_speed
var has_key : = false
var on_water = 0

export var has_boots = false
export var punching = false

func _ready():
	breath = $Timer_Breath.wait_time
	state = states.RUN
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("punch"):
		punching = true
		punch_timer.start()
	if !has_boots:
		jump_speed = JUMP
	else:
		jump_speed = JUMP + BOOT_JUMP
	var input = _get_input_direction()
	match state:
		states.RUN:
			$AudioAgua.playing = false
			if !$AudioAndar.playing:
				$AudioAndar.playing = true
			_apply_movement(input, RUNNING_SPEED)
			$AnimationPlayer.play("Run")
			
				
			if is_on_floor():
				if input == 0:
					state = states.IDLE
				elif Input.is_action_pressed("ui_up"):
					
					_jump(jump_speed)
			else:
				state = states.JUMP
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
		
		states.JUMP:
			$AudioAndar.playing = false
			$AudioAgua.playing = false
			$AnimationPlayer.play("Jump")
			_apply_gravity(delta)
			_apply_movement(input, AIR_SPEED)
			
			if is_on_floor():
				if input == 0:
					state = states.IDLE
				else:
					state = states.RUN
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
		
		states.DEATH:
			$AudioAndar.playing = false
			$AudioAgua.playing = false
			_apply_movement(0, 0)
			_apply_gravity(delta)
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
			get_tree().reload_current_scene()
			#print("died")
		
		states.IDLE:
			$AudioAndar.playing = false
			$AudioAgua.playing = false
			$AnimationPlayer.play("Idle")
			if is_on_floor():
				if input != 0:
					state = states.RUN
				if Input.is_action_pressed("ui_up"):
					_jump(jump_speed)
			else:
				state = states.JUMP
				
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)	

		states.SWIM:
			$AudioAndar.playing = false
			$AnimationPlayer.play("Swim")
			current_time = OS.get_unix_time()
			breath = $Timer_Breath.wait_time - ((current_time - start_time) % 60)
			$Label.text = String(breath)
			print(breath)
			_sink(delta)
			_apply_movement(input, SWIM_SPEED)
			if enable_swim and Input.is_action_pressed("ui_up"):
				_jump(SWIM_UP)
				enable_swim = false
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)
			
		states.CLIMB:
			$AudioAndar.playing = false
			$AudioAgua.playing = false			
			$AnimationPlayer.play("Rope")
			var vinput = _get_vertical_input_direction()
			_apply_vertical_movement(vinput, CLIMB_SPEED)
#			_apply_movement(_get_input_direction(), AIR_SPEED)

			movement = move_and_slide(movement)
			
			pass
			
		states.INTERACTING:
			$AudioAndar.playing = false
			$AudioAgua.playing = false			
			$AnimationPlayer.play("Idle")
			_apply_movement(0, 0)
			_apply_gravity(delta)
			
			movement = move_and_slide_with_snap(movement, Vector2(0,0.2),Vector2.UP)

			
	## AUDIO HANDLING ##

	#print(state)

func _get_input_direction() -> int:
	if !(Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
		balance = 0
		return 0

	if Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_left"):
		balance = 1
		$Sprite.flip_h = false
		return 1

	if !Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		balance = -1
		$Sprite.flip_h = true
		return -1

	if balance == 1 and Input.is_action_pressed("ui_left"):
		$Sprite.flip_h = true
		return -1

	if balance == -1 and Input.is_action_pressed("ui_right"):
		$Sprite.flip_h = false
		return 1

	return 0
	
func _get_vertical_input_direction() -> int:
	return int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	
func _apply_movement(input : int, speed : float) -> void:
	movement.x = input * speed
	
func _apply_vertical_movement(input : int, speed : float) -> void:
	movement.y = input * speed
	pass
	
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
	if body.name == "Player":
		if on_water == 0:
			$AudioAgua.playing = true
			breath_timer.start()
			breath = $Timer_Breath.wait_time
			start_time = OS.get_unix_time()
		on_water += 1
		state = states.SWIM

func _on_Water_body_exited(body):
	if body.name == "Player":
		on_water -= 1
		if on_water == 0:
			$Timer_Breath.stop()
			state = states.IDLE


func _on_Timer_Swim_timeout():
	enable_swim = true


func _on_Timer_Breath_timeout():
	state = states.DEATH
	print("breath")

func _on_Rope_body_entered(body):
	if body.name == "Player":
		state = states.CLIMB
	pass # Replace with function body.


func _on_Rope_body_exited(body):
	if body.name == "Player":
		state = states.JUMP
	pass # Replace with function body.


func _on_Spike_body_entered(body):
	if body.name == "Player":
		state = states.DEATH
		print("spike")
	


func _on_Punch_Timer_timeout():
	punching = false

func _on_Punch_Area_body_entered(body):
	if punching:
		if body.name == "Monster":
			body.health -= 1
			if body.health == 0:
				body.queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Monster":
		state = states.DEATH
		print("monster")


func _on_Chave_body_entered(body):
	if body.name == "Player":
		has_key = true
	pass # Replace with function body.
