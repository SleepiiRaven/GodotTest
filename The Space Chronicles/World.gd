extends Node2D

var enemy = 21

func _ready():
	$MusicOff.play("MusicIn")
	$MusicPlayer.play()

func _unhandled_input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _physics_process(_delta):
	var enemy_list = get_tree().get_nodes_in_group("enemy")
	enemy = enemy_list.size()
	for i in enemy:
		if enemy_list[i].get_node("Sprite").visible == false:
			enemy -= 1
	if enemy != 1 and enemy != 0:
		$CanvasLayer/GameScore.text = ("There are currently " + str(enemy) + " enemies left")
	elif enemy == 1:
		$CanvasLayer/GameScore.text = ("There is currently " + str(enemy) + " enemy left")
	elif enemy == 0:
		$CanvasLayer/GameScore.text = ("All enemies have been defeated! Nice job!")
	
func _on_BossKillTimer_timeout():
	$CanvasLayer/AnimationPlayer.play("Fade")

func _on_AnimationPlayer_animation_finished(_anim_name):
	$CanvasLayer/BossKillText.visible = false

func _on_EnemyBoss_dead():
	$CanvasLayer/BossKillText.text = "Voltoris Vanquished!"
	$CanvasLayer/BossKillText.visible = true
	$BossKillTimer.start()
	$MusicOff.play("MusicFade")

func _on_Player_dead():
	$MusicOff.play("MusicFade")
	$CanvasLayer/DeathMenu.is_paused = true
	$CanvasLayer/DeathMenu/AnimationPlayer.play("FadeIn")
