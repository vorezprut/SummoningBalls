extends Node3D

var demon_scene = preload("res://demon.tscn")
var human_scene = preload("res://human.tscn")
var bloodstains = []
@export var blood_color = Color.RED

func _ready():
	pass
	for i in range(700):
		var d = demon_scene.instantiate()
		d.position = %Player.global_position + Vector3(randf_range(-10, 10), 1, randf_range(-10, 10))
		add_child(d)

func _process(delta):
	%Camera.position = %Player.position
	%Camera.position.y = %Camera.position.y + 20
	%Camera.position.z += 10
	
	%demon_icon.rotation.y += delta
	
	%hp.value = %Player.hp
	%MinionCount.text = str(len(get_tree().get_nodes_in_group("demon")))

	#var d = demon_scene.instantiate()
	#d.position = Vector3(randf_range(-10, 10), 1, randf_range(-10, 10))
	#add_child(d)

func add_blood(pos):
	var vp_size = %blood_vp.size
	var bp_size = %bloodplane.mesh.size
	bloodstains.append(Vector2(pos.x * (vp_size.x / bp_size.x) + vp_size.x/2.0, pos.z * (vp_size.y / bp_size.y) + vp_size.y/2.0))
	%pen.queue_redraw()

func _on_draw_blood():
	for b in bloodstains:
		for i in range(10):
			%pen.draw_circle(b + _random_inside_unit_circle() * 30, randf_range(2, 8), blood_color)
	bloodstains.clear()

func _random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())


func _on_lava_body_entered(body):
	if body.is_in_group("demon") or body.is_in_group("human"):
		body.call_deferred("queue_free")
	elif body.is_in_group("player"):
		body.hp -= 100
		

func _on_spawn_timer_timeout():
	var s = get_tree().get_nodes_in_group("human_spawner").pick_random()
	for i in range(3):
		var h = human_scene.instantiate()
		add_child(h)
		h.global_position = s.global_position + Vector3(randf_range(-10, 10), 1, randf_range(-10, 10))
