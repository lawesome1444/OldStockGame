extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Setting up so that the appropriate script here is executed
	# when the appropriate Firebase condition is met
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	Firebase.Auth.signup_failed.connect(on_signup_failed)

func _on_login_button_pressed():
	# Grab the Email and Password from the entry fields
	var email = %EmailInput.text
	var password = %PasswordInput.text
	# Attempt to login to Firebase
	Firebase.Auth.login_with_email_and_password(email, password)
	%StateLabel.text = "Logging in..."

func _on_signup_button_pressed():
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
	
func on_signup_succeeded(res):
	print(res)
	%StateLabel.text = "Sign Up succeeded!"
	
# If logging in / signing up was unsuccessful, display the appropriate message
func on_login_failed(res, mes):
	print(res)
	print(mes)
	%StateLabel.text = "Login failed. Error: " + str(mes)
	
func on_signup_failed(res, mes):
	print(res)
	print(mes)
	%StateLabel.text = "Sign Up failed. Error: " + str(mes)
	
	
	
	
