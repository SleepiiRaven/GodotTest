extends Control

var is_paused = false setget set_is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_RestartBtn_pressed():
	self.is_paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_QuitBtn_pressed():
	get_tree().quit()
