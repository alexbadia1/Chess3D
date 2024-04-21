extends Area3D

var _board_node
@export var _board_position: String


# Called when the node enters the scene tree for the first time.
func _ready():
	_board_node = get_parent()
	var child_node = get_node("ColorSquare")
	child_node.material = child_node.material.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_board_node._on_square_hover(_board_position)
