extends RigidBody3D


@onready var main = get_node("/root/main")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	main.add_blood(global_position)
	queue_free()
