extends CharacterBody3D


const SPEED = 6.25
const JUMP_VELOCITY = 4.5
var jumping

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
## Create a camera variable
var camera


#Import UI Elements
var xSpeed
var ySpeed
var zSpeed
var rotationgui

# Called when the node enters the scene tree for the first time.
func _ready():
	# Import camera
	camera = get_node("./OrbitCamera")
	#Import UI
	xSpeed = get_node("../../GUI/xSpeed")
	ySpeed = get_node("../../GUI/ySpeed")
	zSpeed = get_node("../../GUI/zSpeed")
	rotationgui = get_node("../../GUI/Rotation")
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	#Check to see if the player is on the ground
	if is_on_floor():
		jumping = false

	# Get the input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
		# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
		
		# Handle Jump Cancel
	if Input.is_action_just_released("jump") and jumping == true and velocity.y > 0:
		velocity.y = 0
		jumping = false
		
		
		# Handle long-jump
	if Input.is_action_just_pressed("long_jump") and is_on_floor():
		velocity.y = 3
		velocity.x = direction.x * 15
		velocity.z = direction.z * 15
		
		# Handle Wall Kicks
	if Input.is_action_just_pressed("jump") and is_on_wall() and not is_on_floor():
		# Give the player some height
		velocity.y = 5
		# Then bounce them off the wall depending on what side of the wall they are facing
		velocity.x = get_wall_normal().x * 7.5
		velocity.z = get_wall_normal().z * 7.5
	
	## Handle Acceleration and Deceleration
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, 15 * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, 15 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, decelerate_player() * delta)
		velocity.z = move_toward(velocity.z, 0, decelerate_player() * delta)
	
	
	xSpeed.text = "X Speed = " + str(velocity.x)
	ySpeed.text = "Y Speed = " + str(velocity.y)
	zSpeed.text = "Z Speed = " + str(velocity.z)
	rotationgui.text = "Rotation = " + str(rotation.y)
	
	
	move_and_slide()

#Calculate Deceleration
func decelerate_player():
	if is_on_floor():
		return 20
	else:
		return 5
