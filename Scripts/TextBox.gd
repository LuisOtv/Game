extends Control

var currentText
@onready var text: RichTextLabel = $Panel/Text
@onready var timer: Timer = $Timer

func updateText():
	text.text = currentText
	timer.start()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel') and visible:
		_closeBox()


func _on_timer_timeout() -> void:
	_closeBox()

func _closeBox():
		visible = false
		currentText = ''
		
		updateText()
