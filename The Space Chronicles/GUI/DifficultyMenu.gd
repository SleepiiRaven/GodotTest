extends Control

var easy = 0.5
var normal = 0.75
var hard = 1

func _on_EasyBtn_pressed():
	Settings.difficulty = easy
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")

func _on_NormalBtn_pressed():
	Settings.difficulty = normal
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")

func _on_HardBtn_pressed():
	Settings.difficulty = hard
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")

func _on_ReturnBtn_pressed():
	visible = false
