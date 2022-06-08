extends Node2D

var enemy = 20

func _physics_process(delta):
	var enemy_list = get_tree().get_nodes_in_group("enemy")
	enemy = enemy_list.size()
	for i in enemy:
		if enemy_list[i].get_node("Sprite").visible == false:
			enemy -= 1
	$CanvasLayer/GameScore.text = ("There are currently " + str(enemy) + " enemies left")
