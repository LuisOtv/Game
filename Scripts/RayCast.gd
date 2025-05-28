extends RayCast3D

@export var label = Label
@export var crosshair = Node3D

func _process(_delta: float) -> void:

	var object = get_collider()

	if object != null and object.is_in_group("Object"):
		crosshair.outer.global_position = object.global_position
		label.text = str(object.object)
		crosshair._showOuter()

		if object.is_in_group("Interactable") and  Input.is_action_just_pressed("ui_f"):
			object._interact()
	else:
		label.text = ""
		crosshair._reset()
