extends StaticBody3D

@onready var breakSound: AudioStreamPlayer3D = $Break
@onready var particles: GPUParticles3D = $GPUParticles3D

func _break():
	particles.emitting = true
	particles.reparent(get_tree().current_scene,true)
	breakSound.play()
	breakSound.reparent(get_tree().current_scene,true)
	queue_free()
