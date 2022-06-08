extends CPUParticles2D

signal exploded

func _ready():
	emitting = true

func _process(_delta):
	if !emitting:
		emit_signal("exploded")
		queue_free()
