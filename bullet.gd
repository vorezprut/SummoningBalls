extends RigidBody3D

var max_killed = 5
var dmg = 5
var bullet_scale = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = max_killed
	$CollisionShape3D.scale = Vector3(bullet_scale, bullet_scale, bullet_scale)
	$MeshInstance3D.scale = Vector3(bullet_scale, bullet_scale, bullet_scale)
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_body_entered(body):
	if max_killed <= 0:
		return
	if body.is_in_group("demon"):
		max_killed -= 1
		if not body.dead:
			body.die()
	elif body.is_in_group("player"):
		body.hp -= dmg
