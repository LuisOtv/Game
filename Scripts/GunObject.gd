extends RigidBody3D

@export var object: String = "holder"

@export var currentAmmo : int
@export var magazineSize : int
@export var extraAmmo : int
@export var pellets : int

@export var automatic : bool
@export var shotgun : bool

@export var bpm : float
@export var gunRecoil : float
@export var cameraRecoil: int
@export var reloadTime : int
@export var scopeFov : int

@onready var weapons = get_tree().get_first_node_in_group("ItemsManager")

func _interact():
	_pickup()

func _pickup():
	var settings ={
		"Gun": object,
		"CurAmmo" : currentAmmo,
		"MagSize" : magazineSize,
		"ExtraAmmo" : extraAmmo,
		"Auto" : automatic,
		"BPM" : bpm,
		"GunRecoil" : gunRecoil,
		"CamRecoil" : cameraRecoil,
		"ReloadTime" : reloadTime,
		"Shotgun" : shotgun,
		"Pellets" : pellets,
		"ScopeFov" : scopeFov,
	}

	if !weapons.holdingGun:
		queue_free()
		weapons._pickup_gun(settings)
