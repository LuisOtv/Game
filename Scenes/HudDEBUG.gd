extends Control

@onready var camera: Camera3D = $"../Neck/Camera3D"
@onready var meters: Label = $CrosshairText/Meters
@onready var spring_arm_3d: SpringArm3D = $"../Neck/Camera3D/SpringArm3D"
@onready var crosshair_text: Control = $CrosshairText
@onready var cross_hair: Node3D = $"../Neck/CrossHair"
@onready var gun_target: Marker3D = $"../Neck/Camera3D/SpringArm3D/GunTarget"

@onready var upgrades: Panel = $Upgrades

# debug
@onready var state: Label = $"../Debug/VBoxContainer/State"
@onready var detection: Label = $"../Debug/VBoxContainer/Detection"
@onready var hp: Label = $"../Debug/VBoxContainer/HP"
@onready var speed: Label = $"../Debug/VBoxContainer/Speed"

@onready var strength: Label = $VBoxContainer2/Strength
@onready var lock_pick: Label = $VBoxContainer2/LockPick
@onready var double_jump: Label = $VBoxContainer2/DoubleJump
@onready var inside_info: Label = $VBoxContainer2/InsideInfo
@onready var fmj: Label = $VBoxContainer2/FMJ
@onready var cloak: Label = $VBoxContainer2/Cloak
@onready var comfy_boots: Label = $VBoxContainer2/ComfyBoots
@onready var cruelty: Label = $VBoxContainer2/Cruelty

@onready var player: CharacterBody3D = $".."

func _process(_delta: float) -> void:
	
	_debugData()

func _debugData():
	state.text = str("State: " + PlayerStats.state)
	detection.text = str("Detection: " + PlayerStats.detection)
	hp.text = str("HP: " + str(PlayerStats.life))
	speed.text = str("Speed: " +  str(player.SPEED))
	
	
	strength.text = str("Speed: " +  str(PlayerStats.strength))
	lock_pick.text = str("Speed: " +  str(PlayerStats.lockPick))
	double_jump.text = str("Speed: " +  str(PlayerStats.doubleJump))
	inside_info.text = str("Speed: " +  str(PlayerStats.insideInfo))
	fmj.text = str("Speed: " +  str(PlayerStats.FMJ))
	cloak.text = str("Speed: " +  str(PlayerStats.cloak))
	comfy_boots.text = str("Speed: " +  str(PlayerStats.comfyBoots))
	cruelty.text = str("Speed: " +  str(PlayerStats.cruelty))
