extends Character

var look_dir : Vector2
var look_dir_locked := false

func _physics_process(_delta : float) -> void:
	if not look_dir_locked:
		look_dir = (Global.Player.position - position).normalized() 
	velocity += look_dir * speed_vector
	rotation = Vector2.DOWN.angle_to(velocity.normalized())
