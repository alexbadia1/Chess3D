extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():	
	var material = load("res://materials/dark.tres")
	for child in get_children():
		if child is MeshInstance3D:
			child.material_override = material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
