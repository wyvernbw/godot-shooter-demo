extends Character
class_name Player

var invincible : bool = false

func _process(_delta) -> void:
	for body in $Hurtbox.get_overlapping_bodies():
		if invincible:
			return
		if body is Character and body.is_in_group("enemy"):
			take_damage(body.damage_mod * 2)
			blood_explode(body.velocity.normalized())
			$iframes.start()
			invincible = true

func _ready() -> void:
	Global.Player = self

func _on_MoveStick_joystick_moved(dir : Vector2) -> void:
	velocity += dir * speed_vector
	rotation = Vector2.DOWN.angle_to(dir)


func _on_ShootStick_joystick_moved(dir : Vector2) -> void:
	rotation = Vector2.DOWN.angle_to(dir)
	var current_skill := $Skills.get_node(selected_skill)
	current_skill.dir = dir
	current_skill.use(self.haste)


func _on_iframes_timeout():
	invincible = false


func _on_Player_died():
	get_tree().paused = true
