extends StaticBody3D
@onready var marker: Marker3D = $ButtonPos
@export var buttons: int
@export var distance: float
@export var startingFloor: int
@export var buttonInstance: PackedScene
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var go_to : Marker3D
@onready var floorsNode: Node3D = $Floors

var b = 0
var moving = false
var curFloor = 0
var floors: Array[Marker3D] = []

func _ready() -> void:
	
	floorsNode.top_level = true
	
	var first_button = buttonInstance.instantiate()
	var first_floor = Marker3D.new()
	floorsNode.add_child(first_floor)
	first_floor.global_position = global_position
	print("Elevator position: ", global_position)
	print("First floor position: ", first_floor.global_position)
	floors.append(first_floor)
	first_button.elevator = self
	first_button.object = str(b) + " Floor"
	first_button.transform.origin = marker.position + Vector3(0, -0.15 * b, 0)
	first_button.floor = first_floor
	add_child(first_button)
	b += 1
	
	for i in range(buttons):
		var floor = Marker3D.new()
		floorsNode.add_child(floor) 
		floor.global_position = Vector3(global_position.x, global_position.y + (distance * b), global_position.z)
		floors.append(floor)
		var instance = buttonInstance.instantiate()
		instance.elevator = self
		instance.object = str(b) + " Floor"
		instance.transform.origin = marker.position + Vector3(0, -0.15 * b, 0)
		instance.floor = floor
		add_child(instance)
		b += 1
	
	if startingFloor >= 0 and startingFloor < floors.size():
		global_position = floors[startingFloor].global_position
		curFloor = startingFloor

func go_to_floor(floor: Marker3D):
	
	if moving:
		return
	
	moving = true
	var elevator_speed = 2.0
	
	while moving:
		var delta = get_process_delta_time()
		var target_pos = floor.global_position
		var current_pos = global_position
		
		var distance_to_target = current_pos.distance_to(target_pos)
		
		if distance_to_target < 0.05:
			moving = false
			global_position = target_pos
			player.global_position.y = global_position.y + 1
			break
		
		global_position = global_position.move_toward(target_pos, elevator_speed * delta)
		player.global_position.y = global_position.y + 1
		
		await get_tree().process_frame
