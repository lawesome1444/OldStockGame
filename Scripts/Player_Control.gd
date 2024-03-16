extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
## Create a camera variable
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	# Import camera
	camera = get_node("./OrbitCamera")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
		# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		# Handle long-jump
	if Input.is_action_just_pressed("long_jump") and is_on_floor():
		velocity.y = 3
		velocity.x = direction.x * 15
		velocity.z = direction.z * 15
	
	## Handle Acceleration and Deceleration
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, 15 * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, 15 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, decelerate_player() * delta)
		velocity.z = move_toward(velocity.z, 0, decelerate_player() * delta)
	
	
	move_and_slide()

#Calculate Deceleration
func decelerate_player():
	if is_on_floor():
		return 20
	else:
		return 1
