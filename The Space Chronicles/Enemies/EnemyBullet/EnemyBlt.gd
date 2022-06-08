extends RigidBody2D

func _on_Hurtbox_body_entered(body):
	if body.is_in_group("environment"):
		queue_free()
	if body.name == "Player":
		queue_free()
