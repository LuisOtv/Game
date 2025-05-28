extends StaticBody3D

var object: String
var elevator: StaticBody3D
var floor: Marker3D
var floorNumber: int

func _interact() -> void:
	if !elevator.moving:
		elevator.go_to_floor(floor)
