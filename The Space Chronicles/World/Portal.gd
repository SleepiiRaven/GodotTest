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
	var next_scene = load(nextscene)
	if "Player" in body.name:
		get_tree().change_scene(nextscene)
