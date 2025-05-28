extends Node3D

@onready var outer: Sprite3D = $OuterCrossHair
@onready var normal: Sprite3D = $NormalCrossHair
@onready var scope: Sprite3D = $ScopeCrossHair

func _ready() -> void:
	top_level = true

func _hideAll():
	normal.visible = false
	outer.visible = false
	scope.visible = false

func _showOuter():
	normal.visible = true
	outer.visible = true
	scope.visible = false

func _showScope():
	normal.visible = false
	outer.visible = false
	scope.visible = true

func _reset():
	normal.visible = true
	outer.visible = false
	scope.visible = false
