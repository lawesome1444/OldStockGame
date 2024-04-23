extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Setting up so that the appropriate script here is executed
	# when the appropriate Firebase condition is met
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)
	
	# If the player is already logged in, enable the highscore button and reflect they are logged in
	var auth = Firebase.Auth.auth
	if auth:
		$"../GridContainer/Button4".disabled = false
		%StateLabel.text = "Logged in"

func _on_login_button_pressed():
	# Grab the Email and Password from the entry fields
	var email = %EmailInput.text
	var password = %PasswordInput.text
	# Attempt to login to Firebase
	Firebase.Auth.login_with_email_and_password(email, password)
	%StateLabel.text = "Logging in..."

func _on_signup_button_pressed():
	# Ensure the user has entered a name
	if $VBoxContainer/Name.text == "":
		%StateLabel.text = "You must enter a name to Sign Up"
	else:
		# Grab the Email and Password from the entry fields
		var email = %EmailInput.text
		var password = %PasswordInput.text
		# Attempt to sign up to Firebase
		Firebase.Auth.signup_with_email_and_password(email, password)
		%StateLabel.text = "Signing up..."
		pass # Replace with function body.

# If logging in / signing up was successful, display the appropriate message
func on_login_succeeded(res):
	print(res)
	%StateLabel.text = "Login succeeded!"
	# Enable the user to view highscores
	$"../GridContainer/Button4".disabled = false
	
func on_signup_succeeded(res):
	print(res)
	%StateLabel.text = "Sign Up succeeded!"
	
	# Add the user name to the new document
	var collection: FirestoreCollection = Firebase.Firestore.collection("highscores")
	var auth = Firebase.Auth.auth
	var data: Dictionary = {
		"name": $VBoxContainer/Name.text
	}
	var upload_task: FirestoreTask = await collection.update(auth.localid, data)
	
# If logging in / signing up was unsuccessful, display the appropriate message
func on_login_failed(res, mes):
	print(res)
	print(mes)
	%StateLabel.text = "Login failed. Error: " + str(mes)
	
func on_signup_failed(res, mes):
	print(res)
	print(mes)
	%StateLabel.text = "Sign Up failed. Error: " + str(mes)
	
	
	
	
