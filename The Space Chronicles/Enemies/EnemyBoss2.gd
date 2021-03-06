extends KinematicBody2D

signal dead
signal found
signal not_found

var BUL_SPD = 600*Settings.difficulty
var SPE_BUL_SPD = 400*Settings.difficulty
var MIN_SPD = .5*Settings.difficulty
var MAX_SPD = 2.3*Settings.difficulty
var speed = MAX_SPD
var vel = Vector2()

var max_hp = 75
var hp = max_hp
var in_area = false
var dead = false
var blt_cd = false
var throwaway_player_detected = false
var player_detected = false
var atk_circle_showing = false
var stuck = false

var player_pos

var portal = preload("res://World/Portal.tscn")
var deathEffect = preload("res://Enemies/BossExplosion.tscn")
var bullet = preload("res://Enemies/EnemyBullet/EnemyBlt.tscn")

enum {
	CHASE,
	SHOOT,
	ATTACK,
	RUSH
}

var state = CHASE


func _ready():
	$StateTimer.start()
	$ShootCooldown.wait_time = rand_range(0.1, 1)

func _physics_process(_delta):
	if dead == false && player_detected == true: 
		match state:
			CHASE:
				chase(get_parent().get_node("Player").position)
			SHOOT:
				var player = get_parent().get_node("Player")
				look_at(player.position)
				if !blt_cd:
					$ShootCooldown.wait_time = rand_range(0.1, 1)
					shoot(BUL_SPD)
			ATTACK:
				attack()
			RUSH:
				$ShootCooldown.wait_time = rand_range(0.05, 0.5)
				rush()
		
		

func chase(pos):
	var motion = Vector2()
	
	motion += (Vector2(pos) - position)
	look_at(pos)
	
	motion = motion.normalized() * speed

# warning-ignore:return_value_discarded
	move_and_collide(motion)

func shoot(spd):
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(spd, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	$ShootSound.play()
	$ShootCooldown.start()
	blt_cd = true
	

func attack():
	var player = get_parent().get_node("Player")
	player_pos = player.position
	look_at(player_pos)
	if !blt_cd:
		$ShootCooldown.wait_time = rand_range(0.3, 3)
		shoot(SPE_BUL_SPD)
		rotation_degrees += 25
		shoot(SPE_BUL_SPD)
		rotation_degrees -= 50
		shoot(SPE_BUL_SPD)

func rush():
	rotation_degrees += 5
	if !blt_cd:
		shoot(BUL_SPD)

func _on_Hitbox_body_entered(body):
	
	if "Bullet" in body.name:
		var damage = body.damage
		if dead == false:
			if hp <= damage:
				var effect = deathEffect.instance()
				effect.global_position = global_position
				get_tree().current_scene.add_child(effect)
				$Sprite.visible = false
				emit_signal("dead")
				$CollisionShape2D.call_deferred("set", "disabled", true)
				set("monitoring", false)
				$AnimationPlayer.play("LightFade")
				$ExplosionSound.play()
				dead = true
				effect.connect("exploded", self, "die")
			else:
				hp -= damage
				$ExplosionSound.play()

func die():
	var portal_instance = portal.instance()
	portal_instance.global_position = global_position
	get_tree().current_scene.add_child(portal_instance)
	queue_free()

# AI Stuff Goes Here #


func _on_StateTimer_timeout():
	$StateTimer.wait_time = rand_range(2,5)
	$StateTimer.start()
	var statenumber = randi() % 4
	match statenumber:
		0:
			state = CHASE
		1:
			state = SHOOT
		2:
			state = ATTACK
		3:
			state = RUSH

func _on_ShootCooldown_timeout():
	blt_cd = false

func _on_PlayerDetect_body_entered(body):
	if "Player" in body.name:
		player_detected = true
		throwaway_player_detected = true
		emit_signal("found")
	if "Bullet" in body.name:
		player_detected = true

func _on_PlayerDetect_body_exited(body):
	if "Player" in body.name || "Bullet" in body.name and !throwaway_player_detected:
		player_detected = false
	elif "Bullet" in body.name and throwaway_player_detected:
		pass
	elif "Player" in body.name and throwaway_player_detected:
		throwaway_player_detected = false
		player_detected = false
		emit_signal("not_found")
		
