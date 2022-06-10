extends KinematicBody2D

const MIN_SPD = 1.5
const MAX_SPD = 3
var speed = 3
var vel = Vector2()

var health = 3
var in_area = false
var dead = false

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
		
func _on_Hitbox_body_entered(body):
	if "Bullet" in body.name:
		if dead == false and health == 1:
			var effect = deathEffect.instance()
			effect.global_position = global_position
			get_tree().current_scene.add_child(effect)
			$Sprite.visible = false
			$CollisionShape2D.call_deferred("set", "disabled", true)
			set("monitoring", false)
			$AnimationPlayer.play("LightFade")
			$DeathSound.play()
			dead = true
			effect.connect("exploded", self, "die")
		elif dead == false:
			$ExplosionSound.play()
			health -= 1
func die():
	queue_free()


func _on_SlowBubble_body_entered(body):
	if "Player" in body.name:
		in_area = true

func _on_SlowBubble_body_exited(body):
	if "Player" in body.name:
		in_area = false
