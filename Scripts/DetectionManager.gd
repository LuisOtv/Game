extends Node

@onready var player: CharacterBody3D = $".."

var scaping = 300
var beeingSaw := false
var caught := false
var trespassing : bool

func _process(_delta: float) -> void:
	if !beeingSaw and PlayerStats.detection == "Fight":
		scaping -= 1 

	if scaping <= 0:
		if caught:
			PlayerStats.detection = "AlertKnow"
		elif !caught:
			PlayerStats.detection = "AlertUnknow"

func _change_state(value):
	if value == "Fight":
		caught = true

	PlayerStats.detection = value
