extends CharacterBody3D


const SPEED = 6.25
const JUMP_VELOCITY = 7.5
var jumping

# Animation player
var animationTree: AnimationTree

# Store all checkpoint coordinates in the level
@export var checkpoint_list = []
# Sets the player's current checkpoint so the game knows where to respawn them
var checkpoint_current = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
## Create a camera variable
var camera


#Import UI Elements
#var xSpeed
#var ySpeed
#var zSpeed
#var rotationgui

# Importing menu
var game_menu
# Called when the node enters the scene tree for the first time.
func _ready():
	# Import camera
	camera = get_node("./OrbitCamera")
	#Import UI
	#xSpeed = get_node("../../GUI/xSpeed")
	#ySpeed = get_node("../../GUI/ySpeed")
	#zSpeed = get_node("../../GUI/zSpeed")
	#rotationgui = get_node("../../GUI/Rotation")
	game_menu = get_node("../../GUI/MenuDim")
	#Get the animation player
	animationTree = get_node("./AnimationTree")
	#animationPlayer.play("idle", -1, 1.0, false)
	camera.focus_btn = get_node("../../GUI/MenuDim/Panel/Resume")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		# Start falling
		animationTree.set("parameters/Blend2/blend_amount", 1)
		# Add gravity
		velocity.y -= gravity * delta
		
	#Check to see if the player is on the ground
	if is_on_floor():
		jumping = false
		animationTree.set("parameters/Blend2/blend_amount", 0)

	# Do not handle any movement if an in-game menu is active
	if camera.menu_block == true:
		game_menu.visible = true
		pass
	else:
		# Hide the in-game menu
		game_menu.visible = false
		# Get the input direction
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		#Set the blend of the animation depending on the axis inputted by the user
		animationTree.set("parameters/BlendSpace2D/blend_position", input_dir)
			
			# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			# Set the blend to jump mode and play the jump animation
			animationTree.set("parameters/Blend2/blend_amount", 1)
			animationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			velocity.y = JUMP_VELOCITY
			jumping = true
			
			# Handle Jump Cancel
		if Input.is_action_just_released("jump") and jumping == true and velocity.y > 0:
			velocity.y = 1
			jumping = false
			
			
			# Handle long-jump
		if Input.is_action_just_pressed("jump") and Input.is_action_pressed("duck") and is_on_floor():
			velocity.y = 4.5
			velocity.x = direction.x * 20
			velocity.z = direction.z * 20
			
			# Handle Wall Kicks
		if Input.is_action_just_pressed("jump") and is_on_wall() and not is_on_floor():
			# Play a jump animation
			animationTree.set("parameters/Blend2/blend_amount", 1)
			animationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			
			# Give the player some height
			velocity.y = 5
			# Then bounce them off the wall depending on what side of the wall they are facing
			velocity.x = get_wall_normal().x * 10
			velocity.z = get_wall_normal().z * 10
		
		## Handle Acceleration and Deceleration
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * SPEED, 15 * delta)
			velocity.z = move_toward(velocity.z, direction.z * SPEED, 15 * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, decelerate_player() * delta)
			velocity.z = move_toward(velocity.z, 0, decelerate_player() * delta)
		
		
		#xSpeed.text = "X Speed = " + str(velocity.x)
		#ySpeed.text = "Y Speed = " + str(velocity.y)
		#zSpeed.text = "Z Speed = " + str(velocity.z)
		#rotationgui.text = "Rotation = " + str(rotation.y)
		
	move_and_slide()

#Calculate Deceleration
func decelerate_player():
	if is_on_floor():
		return 20
	else:
		return 5

# If the player dies, respawn them at the current checkpoint
func _on_player_death(body):
	if body is CharacterBody3D:
		global_position = checkpoint_list[checkpoint_current]

# If the player hits a checkpoint, set the current checkpoint as it
func _on_checkpoint_reached(body, checkpoint):
	if body is CharacterBody3D:
		checkpoint_current = checkpoint
