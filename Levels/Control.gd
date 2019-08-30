extends Control

export (String, "fase1", "fase2", "fase3", "fase4", "fase5") var fase 

var current_dialog 
var dialog_active
var dialog_index: int = 0

func _ready():
	visible = false
	pass # Replace with function body.

func _process(delta):
	if dialog_active:
		$Label.text = current_dialog[dialog_index].fala

func _on_Maurcio_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("mauricio")
	pass # Replace with function body.

func _start_dialog(character : String):
	dialog_active = true
	current_dialog = _fetch_dialog(character)
	print(current_dialog)
	visible = true
	pass
	
func _fetch_dialog(character : String):
	print(fase)
	match fase:
		"fase1":
			print("hy")
			if character == "mauricio":
				return DialogDict.data.fase1[0]
			elif character == "virgilio":
				return DialogDict.data.fase1[1]
		"fase2":
			pass
		"fase3":
			pass
		"fase4":
			pass
		"fase5":
			pass
			
			
func _on_Dialgue_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if dialog_active and dialog_index < current_dialog.size():
			dialog_index += 1
		pass # Replace with function body.
