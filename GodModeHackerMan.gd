extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("f1"):
		get_tree().change_scene("res://Levels/Nivel1.tscn")
	if Input.is_action_just_pressed("f2"):
		get_tree().change_scene("res://Levels/Nivel2.tscn")
	if Input.is_action_just_pressed("f3"):
		get_tree().change_scene("res://Levels/Nivel3.tscn")
	if Input.is_action_just_pressed("f4"):
		get_tree().change_scene("res://Levels/Nivel4.tscn")
	if Input.is_action_just_pressed("f5"):
		get_tree().change_scene("res://Levels/Nivel5.tscn")
	if Input.is_action_just_pressed("f6"):
		get_tree().change_scene("res://Levels/Nivel6.tscn")
	if Input.is_action_just_pressed("f7"):
		get_tree().change_scene("res://Levels/Final.tscn")
#	pass
