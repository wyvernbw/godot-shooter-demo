extends Skill

export var dash_length : float = 0.1

func _ready() -> void:
	$DashTimer.wait_time = dash_length

func action() -> void:
	target.look_dir_locked = true
	target.speed_vector *= 50 
	$DashTimer.start()


func _on_DashTimer_timeout():
	target.speed_vector = Vector2(target.speed, target.speed)
	target.look_dir_locked = false
