extends Node3D

var human_scene = preload("res://human.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	for i in range(3):
		var h = human_scene.instantiate()
		add_child(h)
		h.global_position = s.global_position + Vector3(randf_range(-10, 10), 1, randf_range(-10, 10))
