extends StaticBody3D

@export var object := "Enemy"
@export  var alertTimer := 100

@onready var textBox = get_tree().get_first_node_in_group("TextBox")
@export var speech: Array[String]

@export var target := false

var playerOnSight := false

@onready var raycast3d: RayCast3D = $RayCast3D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var detectionManager = get_tree().get_first_node_in_group("StateManager")
@onready var itensManager = get_tree().get_first_node_in_group("ItemsManager")

func _process(_delta: float) -> void:
	if playerOnSight:
		raycast3d.look_at(player.global_position,Vector3.UP)

		if raycast3d.get_collider() == player:
			if itensManager.holdingGun or detectionManager.trespassing:
				alertTimer -= 1
				detectionManager.beeingSaw = true
				detectionManager.scaping = 300
				if alertTimer <= 0:
					detectionManager._change_state("Fight")

			if PlayerStats.state == "AlertKnow":
				alertTimer -= 3
				detectionManager.beeingSaw = true
				detectionManager.scaping = 300
				if alertTimer <= 0:
					detectionManager._change_state("Fight")

		elif alertTimer < 100:
			alertTimer += 1

	else:
		detectionManager.beeingSaw = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		playerOnSight = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		playerOnSight = false

func _interact():
	textBox.visible = true
	textBox.currentText = speech.pick_random()
	textBox.updateText()
