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
		for i in PlayerStats.keys:
			if i == Key:
				locked = false
				unlockDoor.play()
	else:
		if !AnimPlayer.is_playing():
			openDoor.play()
			if open:
				AnimPlayer.play("close")
				open = false
			else:
				AnimPlayer.play("open")
				open = true
