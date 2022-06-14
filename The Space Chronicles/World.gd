extends Node2D

var enemy = 21
var bossbar_showing = false
var this_boss = null

func _ready():
	$MusicOff.play("MusicIn")
	$MusicPlayer.play()
	if get_tree().current_scene.name == "World":
		$CanvasLayer/TutorialText.text = "WASD to move      Left Click to shoot"
		$CanvasLayer/TutorialText.visible = true
		$TutorialFadeTimer.start()
	if get_tree().current_scene.name != "World" and get_tree().current_scene.name != "World2":
		if get_tree().current_scene.name == "World3":
			$CanvasLayer/TutorialText.text = "Right Click for a stronger shot"
			$CanvasLayer/TutorialText.visible = true
			$TutorialFadeTimer.start()
		$YSort/Player.unlocked_alt = true

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
	
	if bossbar_showing:
		$CanvasLayer/BossBar/TextureProgress.value = this_boss.hp
	

func _on_EnemyBoss_dead():
	bossbar_showing = false
	$CanvasLayer/BossBar.visible = false
	$CanvasLayer/BossKillText.text = "Varvaros Vanquished!"
	$CanvasLayer/BossKillText.visible = true
	$BossKillTimer.start()
	$MusicOff.play("MusicFade")

func _on_EnemyBoss2_dead():
	bossbar_showing = false
	$CanvasLayer/BossBar.visible = false
	$CanvasLayer/BossKillText.text = "Kanoni Vanquished!"
	$CanvasLayer/BossKillText.visible = true
	$BossKillTimer.start()
	$MusicOff.play("MusicFade")

func _on_EnemyBoss3_dead():
	bossbar_showing = false
	$CanvasLayer/BossBar.visible = false
	$CanvasLayer/BossKillText.text = "Astra Vanquished!"
	$CanvasLayer/BossKillText.visible = true
	$BossKillTimer.start()
	$MusicOff.play("MusicFade")


func _on_Player_dead():
	$MusicOff.play("MusicFade")
	$CanvasLayer/DeathMenu.is_paused = true
	$CanvasLayer/DeathMenu/AnimationPlayer.play("FadeIn")

func _on_BossKillTimer_timeout():
	$CanvasLayer/AnimationPlayer.play("Fade")

func _on_AnimationPlayer_animation_finished(_anim_name):
	$CanvasLayer/BossKillText.visible = false

func _on_TutorialFadeTimer_timeout():
	$CanvasLayer/AnimationPlayerTutorial.play("Fade")

func _on_AnimationPlayerTutorial_animation_finished(_anim_name):
	$CanvasLayer/TutorialText.visible = false

func _on_EnemyBoss_found():
	this_boss = $YSort/EnemyBoss
	$CanvasLayer/BossBar.visible = true
	$CanvasLayer/BossBar/TextureProgress.max_value = this_boss.max_hp
	bossbar_showing = true

func _on_EnemyBoss2_found():
	this_boss = $YSort/EnemyBoss2
	$CanvasLayer/BossBar.visible = true
	$CanvasLayer/BossBar/TextureProgress.max_value = this_boss.max_hp
	bossbar_showing = true

func _on_EnemyBoss3_found():
	this_boss = $YSort/EnemyBoss3
	$CanvasLayer/BossBar.visible = true
	$CanvasLayer/BossBar/TextureProgress.max_value = this_boss.max_hp
	bossbar_showing = true

func _on_EnemyBoss_not_found():
	$CanvasLayer/BossBar.visible = false
	bossbar_showing = false

func _on_EnemyBoss2_not_found():
	$CanvasLayer/BossBar.visible = false
	bossbar_showing = false

func _on_EnemyBoss3_not_found():
	$CanvasLayer/BossBar.visible = false
	bossbar_showing = false
