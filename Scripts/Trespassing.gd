extends Node3D

@onready var detectionManager = get_tree().get_first_node_in_group("StateManager")
@onready var player = get_tree().get_first_node_in_group("Player")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		detectionManager.trespassing = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		detectionManager.trespassing = false
