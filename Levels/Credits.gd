extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var finished = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false
	$Sprite.visible = false
	$Label2.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if finished and Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://MainMenu.tscn")
#	pass


func _on_EndGame_body_entered(body):
	$Label.visible = true
	ST.playing = true
	pass # Replace with function body.


func _on_EndGameTitle_body_entered(body):
	$Sprite.visible = true
	pass # Replace with function body.


func _on_EndGameFinish_body_entered(body):
	$Label2.visible = true
	finished = true
	pass # Replace with function body.


func _on_Morte_body_entered(body):
	pass # Replace with function body.
