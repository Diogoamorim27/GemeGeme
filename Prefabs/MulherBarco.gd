extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_entered = false
var pos_y
# Called when the node enters the scene tree for the first time.
func _ready():
	pos_y = self.global_position.y
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_entered:
		move_and_slide(Vector2(50,0),Vector2.UP)
		self.global_position.y = pos_y
#	pass






func _on_AreaMulher_body_exited(body):
	if body.name == "Player":
		player_entered = true
	pass # Replace with function body.
