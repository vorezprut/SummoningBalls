extends RigidBody3D

@onready var demon_target = global_position

func _physics_process(delta):
	linear_velocity.x /= 1 + 3 * delta
	linear_velocity.z /= 1 + 3 * delta
	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	direction = Vector3(direction.x, 0, direction.y)
	apply_central_impulse(direction * delta * 150)
	
	%Anchor.global_position = global_position
	%Anchor.global_position.y += 3
	
	demon_target = global_position
	if Input.is_action_pressed("click"):
		var pos = get_viewport().get_mouse_position()
		var camera3d = get_viewport().get_camera_3d()
		var origin = camera3d.project_ray_origin(pos)
		var end = origin + camera3d.project_ray_normal(pos) * 1000
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(origin, end, 1)
		query.collide_with_areas = true
		demon_target = space_state.intersect_ray(query)["position"]