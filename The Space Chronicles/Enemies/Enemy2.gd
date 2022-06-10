extends KinematicBody2D

const BUL_SPD = 200
const MIN_SPD = 0.5
const MAX_SPD = 1
var speed = 1
var vel = Vector2()

var blt_cd = false
var in_area = false
var shoot_range = false

var dead = false

var bullet = preload("res://Enemies/EnemyBullet/EnemyBlt.tscn")
var deathEffect = preload("res://Enemies/EnemyExplosion.tscn")


func _ready():
	pass

func _physics_process(_delta):
	if dead == false:
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
		if !blt_cd and shoot_range:
			$ShootCooldown.wait_time = rand_range(0.3, 2)
			shoot(BUL_SPD)

func shoot(spd):
	var bullet_instance = bullet.instance()
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(spd, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)
	$ShootSound.play()
	$ShootCooldown.start()
	blt_cd = true
	

func _on_Hitbox_body_entered(body):
	if "Bullet" in body.name:
		if dead == false:
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

func die():
	queue_free()


func _on_SlowBubble_body_entered(body):
	if "Player" in body.name:
		in_area = true

func _on_SlowBubble_body_exited(body):
	if "Player" in body.name:
		in_area = false

func _on_ShootCooldown_timeout():
	blt_cd = false

func _on_PlayerDetect_body_entered(body):
	if "Player" in body.name:
		shoot_range = true

func _on_PlayerDetect_body_exited(body):
	if "Player" in body.name:
		shoot_range = false
