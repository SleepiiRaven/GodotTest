extends Node2D

var nextscene

func _ready():
	var lv1 = "res://World.tscn"
	var lv2 = "res://World2.tscn"
	if get_tree().get_current_scene().get_name() == "World":
		nextscene = lv2
	else:
		nextscene = lv1
	$AnimationPlayer.play("Fade In")

func _on_Area2D_body_entered(body):
	var next_scene = load(nextscene)
	if "Player" in body.name:
		get_tree().change_scene(nextscene)
