extends RigidBody3D

@export var object: String = "holder"
@export var required_strength: int = 1

var being_held: bool

@onready var mesh: MeshInstance3D = $Mesh
@onready var colision: CollisionShape3D = $Colision

@onready var items = get_tree().get_first_node_in_group("ItemsManager")

func _interact():
	if items.heldObject == null and required_strength <= PlayerStats.strength:
		items._hold_object(self)
