extends Node3D

@onready var crosshair: Node3D = $"../../CrossHair"
@onready var equip: AudioStreamPlayer3D = $"../../../Sounds/Equip"
@onready var objectPlace: Marker3D = $"../Drop"
@onready var lowerPos: Marker3D = $"../../LowerPos"

@export_category("Weapons")
@onready var p250: Node3D = $P250
@onready var m4: Node3D = $M4
@onready var m24: Node3D = $M24
@onready var browning: Node3D = $Browning

var holdingGun: bool
var heldGun: Node3D

var holdingObject: bool
var heldObject: Node3D

var direction: Vector3

func _process(_delta: float) -> void:

	direction = (crosshair.global_transform.origin - global_transform.origin).normalized()

	if holdingObject:
		heldObject.global_transform = objectPlace.global_transform

	look_at(crosshair.global_transform.origin, Vector3.UP)
	rotation.z = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_g"):
		if holdingObject:
			_throw_object()
		elif holdingGun:
			_drop_gun()

func _pickup_gun(settings):
	heldGun = get(settings["Gun"])

	heldGun.active = true
	heldGun.currentAmmo = settings["CurAmmo"]
	heldGun.magazineSize = settings["MagSize"]
	heldGun.extraAmmo = settings["ExtraAmmo"]
	heldGun.automatic = settings["Auto"]
	heldGun.bpm = settings["BPM"]
	heldGun.gunRecoil = settings["GunRecoil"]
	heldGun.cameraRecoil = settings["CamRecoil"]
	heldGun.reloadTime = settings["ReloadTime"]
	heldGun.shotgun = settings["Shotgun"]
	heldGun.pellets = settings["Pellets"]
	heldGun.scopeFov = settings["ScopeFov"]

	equip.play()

	holdingGun = true

func _drop_gun():
	var droppedGun = heldGun.gunDrop.instantiate()
	droppedGun.global_position = objectPlace.global_position
	droppedGun.rotate_y(randf_range(0, TAU))
	droppedGun.rotate_z(randf_range(0, TAU))

	droppedGun.object = heldGun.object
	droppedGun.magazineSize = heldGun.magazineSize
	droppedGun.extraAmmo = heldGun.extraAmmo
	droppedGun.automatic = heldGun.automatic
	droppedGun.bpm = heldGun.bpm
	droppedGun.currentAmmo = heldGun.currentAmmo
	droppedGun.reloadTime = heldGun.reloadTime
	droppedGun.gunRecoil = heldGun.gunRecoil
	droppedGun.cameraRecoil = heldGun.cameraRecoil
	droppedGun.scopeFov = heldGun.scopeFov
	droppedGun.linear_velocity = direction

	get_tree().current_scene.add_child(droppedGun)
	
	heldGun._reset()
	
	holdingGun = false
	heldGun = null

func _hold_object(object):
	holdingObject = true
	heldObject = object
	heldObject.colision.disabled = true

func _throw_object():
	holdingObject = false
	heldObject.linear_velocity = direction
	heldObject.colision.disabled = false
	heldObject = null
