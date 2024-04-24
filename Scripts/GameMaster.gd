extends Node3D

var time : float

var timeGUI

# Called when the node enters the scene tree for the first time.
func _ready():
	timeGUI = get_node("GUI/Panel/Label")
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
		# Save the time if the player is logged in
		var auth = Firebase.Auth.auth
		if auth && level < 100:
			# Set the database collection target to the highscores collection
			var collection: FirestoreCollection = Firebase.Firestore.collection("highscores")
			# Grab the player's data
			var download_task: FirestoreTask = collection.get_doc(auth.localid)
			var finished_task: FirestoreTask = await download_task.task_finished
			# Store the player's data in cloud_data
			var cloud_data = finished_task.document
			# The finished time we wish to upload
			var data: Dictionary = {
				currentLevel: time
			}
			# If the player doesn't have a level completion time, do not run the completion time comparison
			# (Because it doesn't exist yet!)
			# This check was made even stricter 
			if cloud_data and cloud_data.doc_fields and cloud_data.doc_fields.has(currentLevel):
				# If the new time is faster (smaller) than the previous, update the best time for the appropriate level
				if time < cloud_data.doc_fields[currentLevel]:
					var upload_task: FirestoreTask = await collection.update(auth.localid, data)
			else:
				# Upload the player's first completion time
				var upload_task: FirestoreTask = await collection.update(auth.localid, data)
		
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print(time)
		get_tree().change_scene_to_file("res://Scenes/DebugMenu.tscn")
		
# handle restarts and exits
func _on_restart_exit(path: String):
	get_tree().change_scene_to_file(path)
	pass
