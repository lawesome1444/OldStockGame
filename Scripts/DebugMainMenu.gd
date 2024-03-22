extends Control

# When a Level's button is selected, it passes on it's scene path to this function
func _debugmenu_buttons(scenePath):
	get_tree().change_scene_to_file(scenePath)
