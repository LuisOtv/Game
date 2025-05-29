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
@onready var player: CharacterBody3D = $".."

func _process(_delta: float) -> void:

	meters.text = str(int(spring_arm_3d.get_hit_length()))
	var crosshair_pos = camera.unproject_position(cross_hair.position)
	cross_hair.global_position = lerp(cross_hair.global_position, gun_target.global_position, 0.3)
	crosshair_text.position = crosshair_pos

func  _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_tab'):
		upgrades.visible = !upgrades.visible 
