extends Node3D

var demon_scene = preload("res://demon.tscn")
var bloodstains = []
@export var blood_color = Color.RED

func _ready():
	for i in range(70):
		var d = demon_scene.instantiate()
		d.position = Vector3(randf_range(-10, 10), 1, randf_range(-10, 10))
		add_child(d)

func _process(delta):
	%Camera.position = %Player.position
	%Camera.position.y = %Camera.position.y / 3 + 20
	%Camera.position.z += 10

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
