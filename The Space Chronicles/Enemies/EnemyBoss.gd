extends KinematicBody2D

const BUL_SPD = 500
const MIN_SPD = .2
const MAX_SPD = 1
var speed = 1
var vel = Vector2()

var hp = 50
var in_area = false
var dead = false
var blt_cd = false

var deathEffect = preload("res://Enemies/EnemyExplosion.tscn")
var bullet = preload("res://Enemies/EnemyBullet/EnemyBlt.tscn")

enum {
	CHASE,
	SHOOT,
	ATTACK
}

var state = CHASE


func _ready():
	$StateTimer.start()
	$ShootCooldown.wait_time = rand_range(0.3, 2)

func _physics_process(_delta):
	if dead == false:
		match state:
			CHASE:
				chase()
			SHOOT:
				var player = get_parent().get_node("Player")
				look_at(player.position)
				if !blt_cd:
					shoot()
			ATTACK:
				attack()
		
		

func chase():
	var motion = Vector2()
	var player = get_parent().get_node("Player")
	
	motion += (Vector2(player.position) - position)
	look_at(player.position)
	
	if in_area && speed > MIN_SPD:
		speed -= .1
	elif !in_area && speed != MAX_SPD:
		speed += .1
	
	motion = motion.normalized() * speed

	move_and_collide(motion)

func shoot():
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(BUL_SPD, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	$ShootSound.play()
	$ShootCooldown.wait_time = rand_range(0.3, 2)
	$ShootCooldown.start()
	blt_cd = true
	

func attack():
	pass

func _on_Hitbox_body_entered(body):
	if "Bullet" in body.name:
		if dead == false:
			if hp == 1:
				var effect = deathEffect.instance()
				effect.global_position = global_position
				get_tree().current_scene.add_child(effect)
				$Sprite.visible = false
				$CollisionShape2D.call_deferred("set", "disabled", true)
				set("monitoring", false)
				$AnimationPlayer.play("LightFade")
				$ExplosionSound.play()
				dead = true
				effect.connect("exploded", self, "die")
			else:
				hp -= 1
				$ExplosionSound.play()

func die():
	queue_free()

# AI Stuff Goes Here #

func _on_SlowBubble_body_entered(body):
	if "Player" in body.name:
		in_area = true

func _on_SlowBubble_body_exited(body):
	if "Player" in body.name:
		in_area = false

func _on_StateTimer_timeout():
	$StateTimer.wait_time = rand_range(2,10)
	$StateTimer.start()
	var statenumber = randi() % 3
	match statenumber:
		0:
			state = CHASE
		1:
			state = SHOOT
		2:
			state = ATTACK

func _on_ShootCooldown_timeout():
	blt_cd = false
