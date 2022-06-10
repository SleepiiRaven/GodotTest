extends Control

func _unhandled_input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _on_StartBtn_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()
