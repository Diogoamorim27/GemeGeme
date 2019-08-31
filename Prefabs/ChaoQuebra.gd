extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var control : Control 
# Called when the node enters the scene tree for the first time.
func _ready():
	control = get_tree().get_nodes_in_group("control")[0]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Dialgue_hide():
	if control:
		if control.current_dialog == DialogDict.data.fase3[1]:
			$AnimationPlayer.play("Break")
			if $CollisionShape2D:
				$CollisionShape2D.queue_free()
	pass # Replace with function body.
