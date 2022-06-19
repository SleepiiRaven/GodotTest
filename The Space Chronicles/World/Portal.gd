extends Node2D

var nextscene

func _ready():
	var lv1 = "res://World.tscn"
	var lv2 = "res://World2.tscn"
	var lv3 = "res://World3.tscn"
	nextscene = lv1
	match get_tree().get_current_scene().get_name():
		"World":
			nextscene = lv2
		"World2":
			nextscene = lv3
	
	$AnimationPlayer.play("Fade In")

func _on_Area2D_body_entered(body):
# warning-ignore:unused_variable
	var next_scene = load(nextscene)
	if "Player" in body.name:
		if body.saved_powerup != null:
			Settings.powerup = body.saved_powerup
			Settings.powerup_time = body.get_node("PowerupTimer").time_left + body.get_node("PowerupDeleteTimer").time_left
		# warning-ignore:return_value_discarded
		get_tree().change_scene(nextscene)
