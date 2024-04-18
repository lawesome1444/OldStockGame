extends Node
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node("ScrollContainer/GridContainer")
	# Store current user authentification
	var auth = Firebase.Auth.auth
	
	# List all documents in the highscores collection
	var list_task: FirestoreTask = Firebase.Firestore.list("highscores")
	# When the "list" function signals (listed_documents) that it has gotten all the documents,
	# call "on_listed_documents to handle the document array
	list_task.listed_documents.connect(_on_listed_documents)
	
func _on_listed_documents(documents: Array):
	# Iterates over every document in the array received from the list() function.
	# At the moment, it only print the info to the console, but later this will populate the "highscore" scene
	for doc in documents:
		print(doc.doc_fields.name)
		if doc.doc_fields.has("level1"):
			print(doc.doc_fields.level1)
		if doc.doc_fields.has("level2"):
			print(doc.doc_fields.level2)
