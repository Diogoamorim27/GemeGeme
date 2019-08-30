extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var has_played = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Dialgue_hide():
	if get_tree().get_nodes_in_group("control")[0].current_dialog == DialogDict.data.fase1[0]:
		if !has_played:
			$AnimationPlayer.play("Open")
			$CollisionShape2D.disabled = true
			has_played = true
	pass # Replace with function body.
