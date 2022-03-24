extends Skill

export var projectile : PackedScene

var dir : Vector2
onready var projectile_color : Color = target.team_color

func action() -> void:
	var projectile_instance := projectile.instance()
	projectile_instance.target = target
	projectile_instance.dir = dir
	projectile_instance.damage *= target.damage_mod
	projectile_instance.global_position = target.position + 8 * dir
	target.get_parent().add_child(projectile_instance)
	
