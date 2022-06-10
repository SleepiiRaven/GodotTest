extends Control

onready var setting_menu = $SettingsMenu
onready var video_settings = $SettingsMenu/MainMenu/SettingsContainer/VideoSettings

func _on_StartBtn_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_SettingsBtn_pressed():
	setting_menu.popup_centered()
	$MainMenu.hide()
	video_settings.show()

func _on_QuitBtn_pressed():
	get_tree().quit()
