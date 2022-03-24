extends Node
class_name Skill

export var mana_cost : int
export var cooldown : float

var target : Node

func _ready() -> void:
	target = get_node("../..")
	$Cooldown.wait_time = cooldown

func _process(_delta) -> void:
	pass

func action() -> void:
	pass
	
func use(haste : float) -> void:
	if not $Cooldown.is_stopped():
		return
	if target.mana <= 0:
		return
	action()
	target.use_mana(mana_cost)
	var reduced_cooldown := cooldown - (cooldown * haste / 100)
	$Cooldown.wait_time = reduced_cooldown
	$Cooldown.start()
