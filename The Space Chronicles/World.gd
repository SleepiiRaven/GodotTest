extends Node2D

var enemy = 20

func _physics_process(_delta):
	enemy = get_tree().get_nodes_in_group("enemy").size()
	$CanvasLayer/GameScore.text = ("There are currently " + str(enemy) + " enemies left")
