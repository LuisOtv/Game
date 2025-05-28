extends StaticBody3D

@export var key : String
@export var object : String

func _interact():
	PlayerStats.keys.append(key)
	queue_free()
