extends Node2D

var enemy = 21

func _physics_process(_delta):
	
	var enemy_list = get_tree().get_nodes_in_group("enemy")
	enemy = enemy_list.size()
	for i in enemy:
		if enemy_list[i].get_node("Sprite").visible == false:
			enemy -= 1
	$CanvasLayer/GameScore.text = ("There are currently " + str(enemy) + " enemies left")
	
func _on_BossKillTimer_timeout():
	$CanvasLayer/AnimationPlayer.play("Fade")

func _on_AnimationPlayer_animation_finished(anim_name):
	$CanvasLayer/BossKillText.visible = false

func _on_EnemyBoss_dead():
	$CanvasLayer/BossKillText.text = "Voltoris Vanquished!"
	$CanvasLayer/BossKillText.visible = true
	$BossKillTimer.start()
	
