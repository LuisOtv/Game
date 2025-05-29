extends CharacterBody3D

@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var crosshair: Node3D = $Neck/CrossHair

@onready var centerPosition: Marker3D = $Neck/CenterPosition
@onready var leanLeft: Marker3D = $Neck/LeanLeft
@onready var leanRight: Marker3D = $Neck/LeanRight
@onready var drop: Marker3D = $Neck/Camera3D/Drop
@onready var standing_col: CollisionShape3D = $StandingCol
@onready var crouching_col: CollisionShape3D = $CrouchingCol
@onready var topDetect: RayCast3D = $TopDetect
@onready var rightDetect: RayCast3D = $RightDetect
@onready var leftDetect: RayCast3D = $LeftDetect

@onready var crouch: Marker3D = $Crouch
@onready var standing: Marker3D = $Standing

var SPEED = 4.0
const CROUCHING_SPEED = 2.0
const LADDER_SPEED = 1.2
const STANDING_SPEED = 4.0
const JUMP_VELOCITY = 5.0

var mouseSensitivity = 0.002
var cameraMinAngle = -80.0 * PI / 180.0
var cameraMaxAngle = 80.0 * PI / 180.0
var cameraRotation = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		rotate_y(-event.relative.x * mouseSensitivity)

		cameraRotation.x -= event.relative.y * mouseSensitivity
		cameraRotation.x = clamp(cameraRotation.x, cameraMinAngle, cameraMaxAngle)
		neck.rotation = cameraRotation

	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:

	if PlayerStats.state == 'Normal':
		if Input.is_action_pressed("ui_control") or topDetect.is_colliding() == true:
			neck.global_position = lerp(neck.global_position,crouch.global_position,0.1)
			standing_col.disabled = true
			SPEED = CROUCHING_SPEED
		else:
			neck.global_position = lerp(neck.global_position,standing.global_position,0.1)
			standing_col.disabled = false
			SPEED = STANDING_SPEED
		
		if Input.is_action_pressed("ui_q") and !leftDetect.is_colliding():
			camera.transform = lerp(camera.transform,leanLeft.transform,0.1)
		elif Input.is_action_pressed("ui_e") and !rightDetect.is_colliding():
			camera.transform = lerp(camera.transform,leanRight.transform,0.1)
		else:
			camera.fov = 75
			camera.transform = lerp(camera.transform,centerPosition.transform,0.1)
	
	elif PlayerStats.state == 'Ladder':
		standing_col.disabled = true
		neck.global_position = lerp(neck.global_position,crouch.global_position,0.1)
		camera.fov = 75

func _physics_process(delta: float) -> void:

	if PlayerStats.state == 'Normal':
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	elif PlayerStats.state == 'Ladder':
		if Input.is_action_pressed("ui_up"):
			velocity.y = LADDER_SPEED
		elif Input.is_action_pressed("ui_down"):
			velocity.y = - LADDER_SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED) 

	move_and_slide()

func _update_life(value):

	PlayerStats.life += value

	if PlayerStats.life <= 0:
		print("dead")

func _double_jump():
	pass
