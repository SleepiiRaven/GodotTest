extends Area2D

var double = preload("res://Art/doublepowerup.png")
var health = preload("res://Art/healthpowerup.png")
var speed = preload("res://Art/lightningpowerup.png")
var shield = preload("res://Art/shieldpowerup.png")
var triple = preload("res://Art/tripleshot.png")
var current_powerup = null

const MAX_SPEED = 200
const ACCELERATION = 200

var powerup_array = [double, health, speed, shield, triple]
var powerup = double
var in_area = false

func _ready():
	randomize()
	var powerupno = round(rand_range(0, powerup_array.size()-1))
	powerup = powerup_array[powerupno]
	$Sprite.texture = powerup

func _on_PowerUp_body_entered(body):
	if "Player" in body.name:
		match powerup:
			double:
				body.current_powerup = "double"
			health:
				body.current_powerup = "health"
			speed:
				body.current_powerup = "speed"
			shield:
				body.current_powerup = "shield"
			triple:
				body.current_powerup = "triple"
		get_parent().get_node("CanvasLayer").get_node("PowerupGUI").get_node("Sprite").texture = powerup
		queue_free()
