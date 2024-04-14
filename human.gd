extends RigidBody3D

var bullet_scene = preload("res://bullet.tscn")
var limb_scene = preload("res://limb.tscn")
@onready var main = get_node("/root/main")
@export var bullet_mass = 50.0
@export var bullet_impact = 100.0
@export var bullet_max_killed = 5
@export var firerate = 1.0
@export var hp = 100.0
@export var movement_speed: float = 3.0
var time_to_shoot = randf_range(0, firerate)


func _ready():
	#go_to_next_place()
	#global_position = %Agent.target_position + Vector3(randf() - 0.5, 0, randf() - 0.5)
	var hat_mat = %Hat.get_active_material(0).duplicate()
	hat_mat.albedo_color = Color.from_hsv(randf(), 0.8, 1)
	%Hat.set_surface_override_material(0, hat_mat)
	var shirt_mat = %Shirt.get_active_material(0).duplicate()
	shirt_mat.albedo_color = Color.from_hsv(randf(), 0.8, 1)
	%Shirt.set_surface_override_material(0, shirt_mat)
	%Boobs.set_surface_override_material(0, shirt_mat)
	%Boobs2.set_surface_override_material(0, shirt_mat)
	var pants_mat = %Pants1.get_active_material(0).duplicate()
	pants_mat.albedo_color = Color.from_hsv(randf(), 0.8, 1)
	%Pants1.set_surface_override_material(0, pants_mat)
	%Pants2.set_surface_override_material(0, pants_mat)
	if randf() > 0.5:
		%Boobs.visible = true
		%Boobs2.visible = true
	#$Timer.wait_time += randf() * 3
	
	%Agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
func _physics_process(delta):
	linear_velocity.x /= 1 + 3 * delta
	linear_velocity.z /= 1 + 3 * delta
	time_to_shoot -= delta
	if time_to_shoot < 0:
		shoot()
		time_to_shoot = firerate
	
	%Agent.target_position = get_tree().get_first_node_in_group("player").global_position
	#if %Agent.is_navigation_finished():
		#return

	var next_path_position: Vector3 = %Agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	%Agent.set_velocity(new_velocity)

func shoot():
	if not visible:
		return
	var shoot_pos = global_position
	shoot_pos.y += 1
	var l = INF
	var closest = null
	for d in get_tree().get_nodes_in_group("demon"):
		var dist = d.global_position.distance_squared_to(shoot_pos)
		if dist < l:
			l = dist
			closest = d
		
	await get_tree().process_frame
	if sqrt(l) > 20 or closest == null:
		return
	var bullet = bullet_scene.instantiate()
	bullet.mass = bullet_mass
	bullet.max_killed = bullet_max_killed
	main.add_child(bullet)
	bullet.global_position = shoot_pos
	bullet.apply_central_impulse(shoot_pos.direction_to(closest.global_position) * bullet_impact)

func _on_body_entered(body):
	if body.is_in_group("demon"):
		main.add_blood(global_position)
		%BloodParticles.emitting = true
		
		#hp -= 10
		hp -= body.last_speed.length_squared() / 10.0 + 3
		if hp <= 0:
			call_deferred("set_contact_monitor", false)
			var demon_pos = body.global_position
			main.add_blood(global_position)
			
			await get_tree().process_frame
			if not is_instance_valid(self):
				return
			for limb in [%Shirt, %Head, %Hat, %Pants1, %Pants2]:
				if not is_instance_valid(limb):
					continue
				var l = limb_scene.instantiate()
				var p = limb.global_position
				var r = limb.global_rotation
				limb.get_parent().remove_child(limb)
				l.add_child(limb)
				limb.position = Vector3.ZERO
				main.add_child(l)
				l.global_position = p
				l.global_rotation = r
				var d = demon_pos.direction_to(global_position)*randf_range(8,12)
				d += Vector3(randf_range(-5,5),randf_range(15,25),randf_range(-5,5))
				l.angular_velocity = d/2.0
				l.apply_central_impulse(d/2.0)
			
			queue_free()
			
func _on_velocity_computed(vel):
	if vel.length() > 0.01:
		var query = PhysicsRayQueryParameters3D.create(global_position + Vector3.UP, global_position + Vector3.DOWN * 1.1, 1)
		if not get_world_3d().direct_space_state.intersect_ray(query):
			return
		
		apply_central_impulse(vel)
		var orig = $Pivot.rotation.y
		vel.y = 0
		$Pivot.look_at(global_position + vel, Vector3.UP)
		$Pivot.rotation.y = lerp_angle(orig, $Pivot.rotation.y, 0.3)
	
