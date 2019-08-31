extends Control

export (String, "fase1", "fase2", "fase3", "fase4", "fase5", "fase6") var fase 

var current_dialog 
var dialog_active = false
var dialog_index: int = 0
var past_dialogs = []

onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	visible = false
	pass # Replace with function body.

func _process(delta):
	if dialog_active:
		
		if Input.is_action_just_pressed("ui_accept"):
			if dialog_index < current_dialog.size() - 1:
				dialog_index += 1
			else:
				_finish_dialog()
		
		if current_dialog[dialog_index].char != "MORTE":
			if $Label2:
				$Label2.text = ""
			$Dialgue.visible = true
			$Label.text = current_dialog[dialog_index].fala
		else: 
			$Label.text = ""
			$Dialgue.visible = false
			if $Label2:
				$Label2.text = current_dialog[dialog_index].fala
				$Label2.visible = true
				print($Label2.text)
			
		if current_dialog[dialog_index].char == "MARCOS":
			$PlayerBust.visible = true
			$SpeakerBust.visible = false
		
		else:
			match current_dialog[dialog_index].char:
				"VIRGILIO":
					$SpeakerBust.texture = load("res://Assets/CharacterArt/personagem_corda.png")
					pass
				"PEDRO":
					$SpeakerBust.texture = load("res://Assets/CharacterArt/personagem_lutador.png")
					pass
				"MAURICIO":
					$SpeakerBust.texture = load("res://Assets/CharacterArt/personagem_porta.png")
					pass
				"MULHER":
					$SpeakerBust.texture = load("res://Prefabs/Mulher Barco.png")
					pass
				"LEO":
					$SpeakerBust.texture = load("res://Assets/CharacterArt/personagem_lenhador.png")
					pass
				"MORTE":
					$SpeakerBust.texture = load("res://Assets/CharacterArt/Morte.png")
			
			$PlayerBust.visible = false
			$SpeakerBust.visible = true
			
		if fase == "fase6":
			$PlayerBust.visible = false
			$SpeakerBust.visible = false

func _on_Maurcio_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("mauricio")
	pass # Replace with function body.

func _start_dialog(character : String):
	current_dialog = _fetch_dialog(character)
	if !current_dialog:
		_finish_dialog()
	if !past_dialogs.has(current_dialog):
		dialog_active = true
		visible = true
		player.state = 6
	else:
		_finish_dialog()
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
			elif character == "virgilio2":
				return DialogDict.data.fase1[2]
		"fase2":
			if character == "leo":
				player.has_boots = true
				return DialogDict.data.fase2[1]
			elif character == "mauricio":
				return DialogDict.data.fase2[0]
			elif character == "virgilio":
				return DialogDict.data.fase2[2]
			elif character == "virgilio2":
				return null
			pass
		"fase3":
			if character == "leo":
				player.has_boots = true
				return DialogDict.data.fase3[0]
			elif character == "virgilio":
				return DialogDict.data.fase3[1]
			elif character == "pedro":
				return DialogDict.data.fase3[2]
			pass
		"fase4":
			if character == "mulher":
				return DialogDict.data.fase4[2]
			elif character == "leo":
				return DialogDict.data.fase4[1]
			elif character == "subleo":
				return DialogDict.data.fase4[0]
			elif character == "pedro":
				return DialogDict.data.fase4[3]
			pass
		"fase5":
			if character == "pedro":
				return DialogDict.data.fase5[0]
				
		"fase6":
			if character == "morte":
				return DialogDict.data.fase6[0]
			
			
func _finish_dialog():
	past_dialogs.append(current_dialog)
	visible = false
	dialog_active = false
	dialog_index = 0
	player.state = 3
	


func _on_Virgilio_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("virgilio")
	pass # Replace with function body.


func _on_Subvirgilio_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("virgilio2")
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("leo")
	pass # Replace with function body.


func _on_Pedro_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("pedro")
	pass # Replace with function body.


func _on_AreaMulher_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("mulher")
	pass # Replace with function body.


func _on_SubLeo_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("subleo")
	pass # Replace with function body.


func _on_Morte_body_entered(body):
	if body.name == "Player":
		visible = true
		_start_dialog("morte")
	pass # Replace with function body.
