extends Node3D

var demon_scene = preload("res://demon.tscn")

@export var num = 100

func _on_area_3d_body_entered(body):
	if not is_instance_valid(%Area3D):
		return
	%Area3D.queue_free()
	%PentFire.emitting = false
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%Pent, "scale", Vector3(0.001, 0.001, 0.001), 2)
	tween.parallel().tween_property(%Tube, "scale:y", 30, 2)
	await tween.finished
	
	%SpawnFire.emitting = true
	for i in range(num):
		var d = demon_scene.instantiate()
		await get_tree().process_frame
		get_node("/root/main").add_child(d)
		d.global_position = global_position
		d.apply_central_impulse(Vector3.UP * 17)
		await get_tree().create_timer(0.1 + randf()/10.0).timeout

	%SpawnFire.emitting = false
	queue_free()
