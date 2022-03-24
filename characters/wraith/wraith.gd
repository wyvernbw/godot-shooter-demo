extends "res://characters/melee_enemy.gd"

export var engage_distance : int

func _ready() -> void:
	$Skills.get_node("Dash").dash_length = 0.05

func _process(_delta) -> void:
	var distance_to_target := Global.Player.position - position
	if distance_to_target.length() <= engage_distance:
		$Skills.get_node("Dash").use(haste)


func _on_DodgeZone_area_entered(area : Area2D):
	if not area is Blast:
		return
	if area.target is Player:
		# dodge
		var distance_to_projectile := area.position - position
		look_dir = distance_to_projectile.normalized().rotated(PI / 2)
		$Skills.get_node("Dash").use(haste)

