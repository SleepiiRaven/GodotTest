extends KinematicBody2D

signal dead

#Varibles
const MAX_SPD = 300
const ACC = 1000
const FRI = 1000
const BUL_SPD = 500

var dead = false
var vel = Vector2.ZERO

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
		
		if Input.is_action_just_pressed("fire"):
			fire()


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
	$ShootSound.play()

func kill():
	emit_signal("dead")
	
func _on_Hitbox_body_entered(body):
	if "Enemy" in body.name:
		if body.get_node("Sprite").visible == true:
			kill()

# ROLL STUFF HERE! #

# ANIMATION STUFF HERE! #
