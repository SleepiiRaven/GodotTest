extends Area2D

var double = preload("res://Art/doublepowerup.png")
var health = preload("res://Art/healthpowerup.png")
var speed = preload("res://Art/lightningpowerup.png")
var shield = preload("res://Art/shieldpowerup.png")
var triple = preload("res://Art/tripleshot.png")

var powerup_array = [double, health, speed, shield, triple]

var powerup = double

func _ready():
	randomize()
	var powerupno = round(rand_range(0, powerup_array.size()))
	powerup = powerup_array[powerupno]
	print(powerup)
	$Sprite.texture = powerup
