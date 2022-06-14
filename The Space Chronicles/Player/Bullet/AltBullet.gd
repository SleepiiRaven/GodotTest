extends RigidBody2D

var damage = 3

func _on_Timer_timeout():
	queue_free()

func _on_Hurtbox_body_entered(body):
	if body.is_in_group("environment"):
		queue_free()
	if "Enemy" in body.name:
			queue_free()
