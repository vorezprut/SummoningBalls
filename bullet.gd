extends RigidBody3D

var max_killed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("demon") and max_killed > 0:
		if body.is_in_group("player"):
			return
		max_killed -= 1
		await get_tree().create_timer(0.2).timeout
		if is_instance_valid(body):
			body.queue_free()
