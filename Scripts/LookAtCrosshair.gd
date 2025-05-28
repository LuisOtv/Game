extends RayCast3D

@onready var marker_3d: Marker3D = $"../Marker3D"

func _process(delta: float) -> void:
	target_position = marker_3d.global_transform.origin
