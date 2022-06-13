extends Control

var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		self.is_paused = !is_paused
		if is_paused == true:
			get_parent().get_parent().get_node("MusicPlayer").set_bus("Muffle")
		else:
			get_parent().get_parent().get_node("MusicPlayer").set_bus("Master")

func set_is_paused(value): 	
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_RestartBtn_pressed():
	self.is_paused = false	

func _on_QuitBtn_pressed():
	get_tree().quit()
