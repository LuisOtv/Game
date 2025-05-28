extends StaticBody3D

@export var object: String = "Ladder"

const STOP_THRESHOLD := 0.05
const MOVE_SPEED := 0.1

@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var bottom: Marker3D = $Bottom
@onready var top: Marker3D = $Top
@onready var move: Timer = $Move
@onready var bottom_drop: Marker3D = $BottomDrop
@onready var top_drop: Marker3D = $TopDrop

var climbing := false
var active := false

var target: Marker3D

func _process(_delta: float) -> void:
	if Player == null or !active:
		return

	if climbing:
		Player.global_transform.origin = Player.global_transform.origin.move_toward(target.global_transform.origin, MOVE_SPEED)
		Player.crouching_col.disabled = true

		if Player.global_transform.origin.distance_to(target.global_transform.origin) < STOP_THRESHOLD:
			climbing = false

	if not climbing:
		_check_exit_bounds()

func _interact():
	if Player != null and PlayerStats.state == "Normal":
		PlayerStats.state = "Ladder"
		active = true
		_get_in()

func _get_in():
	var bottom_dis = Player.global_transform.origin.distance_to(bottom.global_transform.origin)
	var top_dis = Player.global_transform.origin.distance_to(top.global_transform.origin)

	target = bottom if bottom_dis < top_dis else top
	climbing = true

func _check_exit_bounds():
	if Player.global_transform.origin.y < bottom.global_transform.origin.y - 0.2:
		_exit_ladder(bottom_drop)
	elif Player.global_transform.origin.y > top.global_transform.origin.y + 0.2:
		_exit_ladder(top_drop)

func _exit_ladder(position: Marker3D):
	Player.global_transform.origin = position.global_transform.origin
	Player.crouching_col.disabled = false
	PlayerStats.state = "Normal"
	Player.velocity.y = 0
	active = false
	climbing = false
