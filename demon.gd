extends RigidBody3D

var player
var last_speed = Vector3.ZERO
var cur_speed = Vector3.ZERO

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	last_speed = cur_speed
	cur_speed = linear_velocity
	#if randf() < 0.05:
		#apply_central_impulse(global_position.direction_to(player.global_position) * delta * 10)
	apply_central_force(global_position.direction_to(player.demon_target) * 11)
