extends RigidBody3D

@onready var particles: GPUParticles3D = $GPUParticles3D

func _on_area_3d_area_entered(area: Area3D) -> void:
	
	var object = area.get_parent()

	if object != null:
		if object.is_in_group('Breakable'):
			object._break()
		elif object.is_in_group('Wall'):
			pass

		particles.emitting = true
		particles.reparent(get_tree().current_scene,true)
		queue_free()
