extends Node

@export var speed = 10.0
@export var mouse_sensitivity = 0.1

var camera
var initial_rotation
var pitch = 0
var yaw = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node('Camera3D')
	initial_rotation = camera.rotation_degrees

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector3()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
			velocity.z -= 1
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			velocity.x -= 1
		if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_RIGHT):
			velocity.z += 1
		if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_DOWN):
			velocity.x += 1
		if Input.is_key_pressed(KEY_E) or Input.is_key_pressed(KEY_SPACE):
			velocity.y += 1
		if Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_CTRL):
			velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * delta
		camera.translate(velocity)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if event is InputEventMouseMotion:
			yaw -= event.relative.x * mouse_sensitivity
			pitch = clamp(pitch - event.relative.y * mouse_sensitivity, -70, 70)
			camera.rotation_degrees = initial_rotation + Vector3(pitch, yaw, 0)
