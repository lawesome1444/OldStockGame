extends Node3D

# Speed of camera rotation
var mouse_speed = 0.1
var controller_speed = 150

# Find out if a in-game menu is open to block attempts to relock the camera to the window
# aka Stop the game from locking the mouse to the window and hiding it
var menu_block = false

# Specifying that the player_node variable is CharacterBody3D
var player_node : CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Set the characterbody3d as the player's one
	player_node = get_node("../../CharacterBody3D")
	# Lock the mouse to the window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	pass # Replace with function body.

func _input(event):
	# If the Menu button is pressed, lock/unlock the mouse to the window
	if event.is_action_pressed("menu"):
		if menu_block == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if menu_block == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		menu_block = !menu_block
		
	# If the user clicks the window, lock the mouse to the game
	if event.is_action_pressed("mouse_1") && menu_block == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Check if the event is mouse motion
	if event is InputEventMouseMotion && menu_block == false:
		# Get the relative motion of the mouse
		var mouse_motion = event.relative
		rotate_camera(mouse_motion, mouse_speed)
		
# Check each frame for controller camera movement. Apply the intensity and multiply by time delta to keep sensititivy consistent between framerates
func _process(delta):
	var controller_motion = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") * delta
	rotate_camera(controller_motion, controller_speed)
	pass

func rotate_camera(rotation, speed):
	# Rotate the camera around the target node
	var new_rotation = self.rotation_degrees
	var new_player_rotation = player_node.global_rotation_degrees
	new_player_rotation.y -= rotation.x * speed
	new_rotation.x -= rotation.y * speed

	# Clamp the rotation to avoid flipping the camera
	new_rotation.x = clamp(new_rotation.x, -89, 89)

	# Apply the new rotation to the camera
	self.rotation_degrees.x = new_rotation.x
	player_node.global_rotation_degrees.y = new_player_rotation.y
	
# IF the resume button is pressed, return to the game and starting capturing the mouse again
func _on_resume_button():
	menu_block = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
