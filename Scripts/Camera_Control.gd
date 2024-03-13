extends Node3D

# Speed of camera rotation
var rotation_speed = 0.1

# Target node to rotate around
var target_node : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	target_node = get_parent_node_3d()
	# Make sure we have a target node
	assert(target_node, "Target node not set for camera rotation!")
	
	# Lock the mouse to the window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	pass # Replace with function body.

func _input(event):
	# If escape is pressed, unlock the window
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	# If the user clicks the window, lock the mouse to the game
	if event.is_action_pressed("mouse_1"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Check if the event is mouse motion
	if event is InputEventMouseMotion:
		# Get the relative motion of the mouse
		var mouse_motion = event.relative

		# Rotate the camera around the target node based on mouse motion
		rotate_camera(mouse_motion)

func rotate_camera(rotation):
	# Rotate the camera around the target node
	var new_rotation = self.rotation_degrees
	new_rotation.y -= rotation.x * rotation_speed
	new_rotation.x -= rotation.y * rotation_speed

	# Clamp the rotation to avoid flipping the camera
	new_rotation.x = clamp(new_rotation.x, -89, 89)

	# Apply the new rotation to the camera
	self.rotation_degrees = new_rotation
	#
