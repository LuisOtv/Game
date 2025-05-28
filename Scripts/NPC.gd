extends StaticBody3D

@export var object:String = 'NPC'
@export var speech: Array[String]

@export var target := false

@onready var textBox = get_tree().get_first_node_in_group("TextBox")

func _interact():
	textBox.visible = true
	textBox.currentText = speech.pick_random()
	textBox.updateText()
