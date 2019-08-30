extends Node

var data

func _ready():
	var data_file = File.new()
	if data_file.open("res://Singletons/dialogues.json", File.READ) != OK:
		return
	var data_text = data_file.get_as_text()
	data_file.close()
#	print(data_text)
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		print("wrong")
		return
	data = data_parse.result
	pass # Replace with function body.
