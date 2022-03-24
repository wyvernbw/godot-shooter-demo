extends CPUParticles2D
class_name BloodParticles

func _on_Timer_timeout():
	set_process_internal(false)
	print("blood paused")
