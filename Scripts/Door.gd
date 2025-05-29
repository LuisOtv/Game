extends StaticBody3D

@export var object: String = "Door"
@export var locked: bool
@export var Key: String

@onready var openDoor: AudioStreamPlayer3D = $"../OpenDoor"
@onready var unlockDoor: AudioStreamPlayer3D = $"../UnlockDoor"

var open = false

@export var AnimPlayer: AnimationPlayer

func _interact():
	if locked:
		if PlayerStats.lockPick:
			_unlock()
		
		for i in PlayerStats.keys:
			if i == Key:
				_unlock()
				
	else:
		if !AnimPlayer.is_playing():
			openDoor.play()
			if open:
				AnimPlayer.play("close")
				open = false
			else:
				AnimPlayer.play("open")
				open = true
				
func _unlock():
		locked = false
		unlockDoor.play()
	
