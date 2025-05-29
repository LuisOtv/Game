extends Node3D

# --- Exported Variables ---
@export var object: String
@export var gunDrop: PackedScene
@export var bullet: PackedScene
@export var fireSound: AudioStreamPlayer3D
@export var reloadSound: AudioStreamPlayer3D
@export var emptySound: AudioStreamPlayer3D

# --- Weapon State Variables ---
var flashTimer: int
var active: bool
var currBpm: int

# --- Ammo ---
var currentAmmo: int
var magazineSize: int
var extraAmmo: int
var currentReloadTime: int
var reloadTime: int
var pellets: int

# --- Weapon Config ---
var automatic: bool
var shotgun: bool
var bpm: int
var gunRecoil: int
var cameraRecoil: int
var scopeFov: int
var timeOut: int

# --- Shooting Direction ---
var direction: Vector3

# --- Node References ---
@onready var camera: Camera3D = $"../.."
@onready var ammo: Label = $"../../../../HUD/CrosshairText/Ammo"
@onready var extra: Label = $"../../../../HUD/CrosshairText/ExtraAmmo"
@onready var crosshair: Node3D = $"../../../CrossHair"
@onready var bulletSpawn: Marker3D = $"../BulletSpawn"
@onready var flash: MultiMeshInstance3D = $Flash
@onready var springArm3D: SpringArm3D = $"../../SpringArm3D"
@onready var weapons: Node3D = $".."
@onready var lowerPos: Marker3D = $"../../../LowerPos"
@onready var shoulderPos: Marker3D = $"../../ShoulderPos"

@onready var player = get_tree().get_first_node_in_group("Player") #might delete

# --- Engine Hooks ---
func _process(_delta: float) -> void:
	direction = (crosshair.global_transform.origin - global_transform.origin).normalized()
	_updateFlash()

	if not active:
		visible = false
		return

	visible = true

	if currentReloadTime >= 0:
		weapons.global_transform.origin = lerp(weapons.global_transform.origin, lowerPos.global_transform.origin, 0.1)
		currentReloadTime -= 1

	elif weapons.holdingObject:
		weapons.global_transform.origin = lerp(weapons.global_transform.origin, lowerPos.global_transform.origin, 0.1)
		return

	else:
		weapons.global_transform.origin = lerp(weapons.global_transform.origin, shoulderPos.global_transform.origin, 0.2)
		_updateUI()
		_handleShooting()
		_handleReload()
		_handleScope()

# --- UI + Visual ---
func _updateFlash() -> void:
	if flashTimer > 0:
		flash.visible = true
		flashTimer -= 1
	else:
		flash.visible = false

func _updateUI() -> void:
	ammo.text = str(currentAmmo)
	extra.text = str(extraAmmo)

# --- Input Handlers ---
func _handleScope():
	if Input.is_action_pressed('ui_mouse_2') and scopeFov > 0:
		camera.fov = scopeFov
		crosshair._showScope()

func _handleShooting() -> void:
	if shotgun:
		if Input.is_action_just_pressed("ui_mouse_1"):
			if currentAmmo > 0:
				_shoot()
			else:
				emptySound.play()
	elif automatic:
		if Input.is_action_pressed("ui_mouse_1"):
			if currBpm <= 0:
				_shoot()
			else:
				currBpm -= 1
		else:
			currBpm = 0
	else:
		if Input.is_action_just_pressed("ui_mouse_1"):
			_shoot()

func _handleReload() -> void:
	if Input.is_action_just_pressed("ui_r") and extraAmmo > 0 and currentAmmo < magazineSize:
		var neededAmmo = magazineSize - currentAmmo
		var ammoToReload = min(neededAmmo, extraAmmo)

		currentAmmo += ammoToReload
		extraAmmo -= ammoToReload
		reloadSound.play()

		currentReloadTime = reloadTime

# --- Shooting Logic ---
func _shoot() -> void:
	if currentAmmo > 0 and timeOut >= 0:
		currentAmmo -= 1
		currBpm = bpm
		flashTimer = 1

		if shotgun:
			for i in range(pellets):
				var spread = Vector3(
					randf_range(-0.05, 0.05),
					randf_range(-0.05, 0.05),
					randf_range(-0.05, 0.05)
				)
				_createBullet((direction + spread).normalized())
		else:
			_createBullet(direction)

		# Crosshair randomness
		crosshair.global_transform.origin += Vector3(
			randf_range((springArm3D.get_hit_length() / gunRecoil) * -1, (springArm3D.get_hit_length() / gunRecoil)),
			randf_range(0, (springArm3D.get_hit_length() / gunRecoil)),0
		)

		# Recoil
		weapons.translate(Vector3(0, 0, 0.01 * gunRecoil))
		fireSound.play()

		# Camera recoil
		camera.rotate_x(0.01 * cameraRecoil)

	else:
		emptySound.play()

func _createBullet(dir: Vector3) -> void:
	
	var newBullet = bullet.instantiate()
	newBullet.position = bulletSpawn.global_transform.origin
	newBullet.linear_velocity = dir * 200
	get_tree().current_scene.add_child(newBullet)


# --- Reset ---
func _reset():
	automatic = false
	active = false
	extraAmmo = 0
	bpm = 0
	currentAmmo = 0
	magazineSize = 0
	ammo.text = ""
	extra.text = ""
