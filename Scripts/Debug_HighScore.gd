extends Node
var grid
var levelQuery #

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node("Control/ScrollContainer/VBoxContainer")
	# Store current user authentification
	var auth = Firebase.Auth.auth
	# Focus on the first button for controller users
	$FilterTabs/Button.grab_focus()
	
	# List all documents in the highscores collection
	var list_task: FirestoreTask = Firebase.Firestore.list("highscores")
	# When the "list" function signals (listed_documents) that it has gotten all the documents,
	# call "on_listed_documents to handle the document array
	list_task.listed_documents.connect(_on_listed_documents)
	
func _on_tab_button(option: int):
	# Delete the old information
	var hBoxParent = get_node("Control/ScrollContainer/VBoxContainer")
	if hBoxParent.get_child_count() != 0: # Ensure the hbox exists (e.g the player clicked a menu option before the data was retrieved from Firebase
		for child in hBoxParent.get_children():
			child.free()
		
	if option == 0:
		# Switch the column labels
		$Control/Panel/AllHBox.visible = true
		$Control/Panel/LevelHBox.visible = false
		var list_task: FirestoreTask = Firebase.Firestore.list("highscores")
		list_task.listed_documents.connect(_on_listed_documents)
	else:
		# Switch the column labels
		$Control/Panel/AllHBox.visible = false
		$Control/Panel/LevelHBox.visible = true
		var query: FirestoreQuery = FirestoreQuery.new()
		var level = "level" + str(option)
		# Building query parameters
		query.from("highscores")
		query.where("level" + str(option), FirestoreQuery.OPERATOR.NOT_EQUAL, null)
		query.order_by(level, FirestoreQuery.DIRECTION.ASCENDING)
		
		# Assign levelQuery the level number so it can omit the other levels
		levelQuery = option
		# Issue the query
		var query_task = Firebase.Firestore.query(query)
		query_task.result_query.connect(_on_result_query)
	
# Handles the "All" tab of Highscores
func _on_listed_documents(documents: Array):
	# Iterates over every document in the array received from the list() function.
	for doc in documents:
		var hbox: HBoxContainer = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		if doc.doc_fields.has("name"):
			print(doc.doc_fields.name)
			var text: Label = Label.new()
			text.set_text(str(doc.doc_fields.name))
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hbox.add_child(text)
		if doc.doc_fields.has("level1") && (levelQuery == 1 || !levelQuery):
			print(doc.doc_fields.level1)
			var time = doc.doc_fields.level1
			var time_string = _formatTime(time)
			var text: Label = Label.new()
			text.set_text(time_string)
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hbox.add_child(text)
		else:
			var text: Label = Label.new()
			text.set_text("N/A")
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hbox.add_child(text)
		if doc.doc_fields.has("level2") && (levelQuery == 2 || !levelQuery):
			print(doc.doc_fields.level2)
			var time = doc.doc_fields.level2
			var time_string = _formatTime(time)
			var text: Label = Label.new()
			text.set_text(time_string)
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hbox.add_child(text)
		else:
			var text: Label = Label.new()
			text.set_text("N/A")
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hbox.add_child(text)
		# Add the finished Player stat entry to highscore list
		grid.add_child(hbox)
	# reset levelQuery
	levelQuery = null
	
# Queried results now use this function. This was done so that the "All" tab could display all users and keep proper grid formatting while also not breaking Level 1 and Level 2's tabs (as they have 2 columns rather than 3)
func _on_result_query(documents: Array):
	# Iterates over every document in the array received from the query() function.
	for doc in documents:
		var hbox: HBoxContainer = HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		if doc.doc_fields.has("name"):
			print(doc.doc_fields.name)
			var text: Label = Label.new()
			text.set_text(str(doc.doc_fields.name))
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hbox.add_child(text)
		if doc.doc_fields.has("level1") && (levelQuery == 1):
			print(doc.doc_fields.level1)
			var time = doc.doc_fields.level1
			var time_string = _formatTime(time)
			var text: Label = Label.new()
			text.set_text(time_string)
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hbox.add_child(text)
		if doc.doc_fields.has("level2") && (levelQuery == 2):
			print(doc.doc_fields.level2)
			var time = doc.doc_fields.level2
			var time_string = _formatTime(time)
			var text: Label = Label.new()
			text.set_text(time_string)
			text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hbox.add_child(text)
			
		# Add the finished Player stat entry to highscore list
		grid.add_child(hbox)
	# reset levelQuery
	levelQuery = null
			
func _formatTime(time):
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	var milliseconds = int((time - floor(time)) * 1000)
	
	# Format the time into a string
	var timeString = ""
	# Add 0s before numbers smaller than 10 (smaller than 100 for milliseconds)
	# Minutes
	if (minutes < 10):
		timeString += "0" + str(minutes) + ":"
	else:
		timeString += str(minutes) + ":"

	# Seconds
	if (seconds < 10):
		timeString += "0" + str(seconds) + ":"
	else:
		timeString += str(seconds) + ":"

	#Milliseconds
	if (milliseconds < 10):
		timeString += "00" + str(milliseconds)
	else: if (milliseconds < 100 &&  milliseconds >= 10):
		timeString += "0" + str(milliseconds)
	else:
		timeString += str(milliseconds)
	return timeString

func _return_to_menu(scenePath):
	get_tree().change_scene_to_file(scenePath)
