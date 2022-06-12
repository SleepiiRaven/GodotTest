extends KinematicBody2D

signal dead

#Varibles
var MAX_SPD = 250
var ACC = 1000
var FRI = 1000
var BUL_SPD = 500
var HP = 1

var invincible = false
var current_powerup = null
var shoot_cd = false
var dead = false
var vel = Vector2.ZERO
var picked_up_powerup = false
var shielded = false
var doubled = false
var tripled = false
var doubled_now = false

#Preloads
var bullet = preload("res://Player/Bullet/Bullet.tscn")

func _ready():
	pass

func _physics_process(delta):
	if !dead:
		#create input vector
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		#NORMALIZE the vector, so diagonal won't be faster
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			vel = vel.move_toward(input_vector * MAX_SPD, ACC * delta)
		else:
			vel = vel.move_toward(Vector2.ZERO, FRI * delta)
		
		#actual movement
		move()
		
		if Input.is_action_pressed("fire") and !shoot_cd:
			fire()
			shoot_cd = true
			$ShootCooldown.start()
			
	
	match current_powerup:
		"double":
			picked_up_powerup = true
			current_powerup = null
			MAX_SPD = 250
			ACC = 1000
			FRI = 1000
			BUL_SPD = 500
			HP = 1
			$ShootCooldown.wait_time = 0.1
			shielded = false
			tripled = false
			doubled = true
			doubled_now = true
			$PowerupTimer.start()
			if get_parent().has_node("Player2"):
				get_parent().get_node("Player2").queue_free()
		"health":
			picked_up_powerup = true
			current_powerup = null
			MAX_SPD = 250
			ACC = 1000
			FRI = 1000
			BUL_SPD = 500
			$ShootCooldown.wait_time = 0.1
			shielded = false
			tripled = false
			doubled = false
			HP = 2
			$PowerupTimer.start()
			if get_parent().has_node("Player2"):
				get_parent().get_node("Player2").queue_free()
		"speed":
			picked_up_powerup = true
			current_powerup = null
			MAX_SPD = 250
			ACC = 1000
			FRI = 1000
			HP = 1
			shielded = false
			tripled = false
			doubled = false
			BUL_SPD = 800
			$ShootCooldown.wait_time = 0.08
			$PowerupTimer.start()
			if get_parent().has_node("Player2"):
				get_parent().get_node("Player2").queue_free()
		"shield":
			picked_up_powerup = true
			current_powerup = null
			MAX_SPD = 250
			ACC = 1000
			FRI = 1000
			BUL_SPD = 500
			HP = 1
			$ShootCooldown.wait_time = 0.1
			tripled = false
			doubled = false
			shielded = true
			$PowerupTimer.start()
			if get_parent().has_node("Player2"):
				get_parent().get_node("Player2").queue_free()
		"triple":
			MAX_SPD = 250
			ACC = 1000
			FRI = 1000
			BUL_SPD = 500
			HP = 1
			$ShootCooldown.wait_time = 0.1
			shielded = false
			doubled = false
			picked_up_powerup = true
			current_powerup = null
			tripled = true
			$PowerupTimer.start()
			if get_parent().has_node("Player2"):
				get_parent().get_node("Player2").queue_free()
	
	if doubled and doubled_now:
		var player_instance = load("res://Player/Player.tscn").instance()
		player_instance.global_position = global_position + Vector2(0,20)
		get_parent().add_child(player_instance)
		doubled_now = false
		
	
	if picked_up_powerup:
		$Powerup.play()
		picked_up_powerup = false
		


func move():
	vel = move_and_slide(vel)
	look_at(get_global_mouse_position())

# GUN STUFF HERE! #
func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(BUL_SPD, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	if tripled:
		var bullet_instance_2 = bullet.instance()
		bullet_instance_2.position = get_global_position()
		bullet_instance_2.rotation_degrees = rotation_degrees
		bullet_instance_2.apply_impulse(Vector2(), Vector2(BUL_SPD, 0).rotated(rotation))
		get_tree().get_root().call_deferred("add_child", bullet_instance_2)
		var bullet_instance_3 = bullet.instance()
		bullet_instance_3.position = get_global_position()
		bullet_instance_3.rotation_degrees = rotation_degrees-45
		bullet_instance_3.apply_impulse(Vector2(), Vector2(BUL_SPD, 0).rotated(rotation-45))
		get_tree().get_root().call_deferred("add_child", bullet_instance_3)
	$ShootSound.play()

func kill():
	emit_signal("dead")
	
func _on_Hitbox_body_entered(body):
	if "Enemy" in body.name:
		if body.get_node("Sprite").visible == true and !invincible:
			if "Blt" in body.name:
				if !shielded:
					if HP == 1:
						kill()
					else:
						HP -= 1
						invincible = true
						$Invincibility.start()
						$Hit.play()
			else:
				if HP == 1:
					kill()
				else:
					HP -= 1
					invincible = true
					$Invincibility.start()
					$Hit.play()
					if HP == 1:
						get_parent().get_parent().get_node("CanvasLayer").get_node("PowerupGUI").get_node("Sprite").texture = null
				

# ROLL STUFF HERE! #

# ANIMATION STUFF HERE! #

func _on_Timer_timeout():
	shoot_cd = false

func _on_Invincibility_timeout():
	invincible = false

func _on_PowerupTimer_timeout():
	$PowerupDeleteTimer.start()
	get_parent().get_parent().get_node("CanvasLayer").get_node("PowerupGUI").get_node("BlinkAnimationPlayer").play("Start")
	#make new timer that's less than powerup timer that makes it flash


func _on_PowerupDeleteTimer_timeout():
	MAX_SPD = 250
	ACC = 1000
	FRI = 1000
	BUL_SPD = 500
	HP = 1
	$ShootCooldown.wait_time = 0.1
	shielded = false
	tripled = false
	doubled = false
	get_parent().get_parent().get_node("CanvasLayer").get_node("PowerupGUI").get_node("BlinkAnimationPlayer").play("Stop")
	get_parent().get_parent().get_node("CanvasLayer").get_node("PowerupGUI").get_node("Sprite").texture = null
	if get_parent().has_node("Player2"):
			get_parent().get_node("Player2").queue_free()
