extends Label3D

@export var damage = 10
var vel

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(round(damage))
	vel = Vector3.UP/5 + Vector3(randf()-0.5, randf()/4, randf()-0.5)/10
	var t = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
	scale = Vector3(0.001, 0.001, 0.001)
	t.tween_property(self, "scale", Vector3.ONE * lerpf(0.3, 0.8, damage/50.0), 0.3)
	t.tween_interval(1)
	t.tween_property(self, "scale", Vector3(0.001, 0.001, 0.001), 1)
	t.tween_callback(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vel += Vector3.DOWN * delta / 3
	position += vel
