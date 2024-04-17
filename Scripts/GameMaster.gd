extends Node3D

var time : float

var timeGUI

# Called when the node enters the scene tree for the first time.
func _ready():
	timeGUI = get_node("GUI/GridContainer/Label")
	pass # Replace with function body.

func _process(delta):
	time += delta
	formatTime(time)
	pass

func formatTime(t):
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	var milliseconds = int((time - floor(time)) * 1000)
	
	var timeString = str(minutes) + ":" + str(seconds) + ":" + str(milliseconds)
	timeGUI.text = timeString
	pass
# Handles level completion. Makes sure that the collision was from the player
func _on_level_completion(body, level):
	if body is CharacterBody3D:
		var currentLevel
		# Godot's switch equivalent, checking the level
		match level:
			1: currentLevel = "level1"
			2: currentLevel = "level2"
		# Save the time
		var auth = Firebase.Auth.auth
		if auth && level < 100:
			var collection: FirestoreCollection = Firebase.Firestore.collection("highscores")
			var data: Dictionary = {
				currentLevel: time
			}
			var task: FirestoreTask = await collection.update(auth.localid, data)
			
		
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print(time)
		get_tree().change_scene_to_file("res://Scenes/DebugMenu.tscn")
