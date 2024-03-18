extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# The following "_menubutton" functions all do the same thing: When the button is pressed, go to the appropriate scene
# NOTE TO SELF: Find a way to pass the scene path as a value to avoid having more than 1 function for this purpose
func _menubutton_debugscene():
	get_tree().change_scene_to_file("res://Scenes/Debug.tscn")
	pass # Replace with function body.
	



func _menubutton_level1():
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn")
	pass # Replace with function body.
