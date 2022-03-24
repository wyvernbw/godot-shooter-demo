extends KinematicBody2D
class_name Character

"""
Generic class for all characters to inherit from. This loads all its stats 
from the resource and contains generic functionality for all the characters
in the game.
"""

signal health_changed(new_health)
signal died

export var starting_stats : Resource
export var selected_skill : String
export var skills : Array
export var team_color := Color.white

onready var blood_particles : PackedScene = preload("res://characters/BloodParticles.tscn")

var max_hp : int setget set_max_hp
var max_mana : int setget set_max_mana
var defense : int
var speed : int
var damage_mod : float
var haste : float

var hp : int 
var mana : int
var velocity := Vector2.ZERO
var speed_vector := Vector2.ZERO
var friction := 0.3
var dead : bool = false

func _ready() -> void:
	initialize()

func _process(_delta) -> void:
	pass

func _physics_process(_delta) -> void:
	velocity.x = lerp(velocity.x, 0, friction)
	velocity.y = lerp(velocity.y, 0, friction)
	velocity = move_and_slide(velocity, Vector2.ZERO)


func initialize() -> void:
	max_hp = starting_stats.max_hp
	max_mana = starting_stats.max_mana
	defense = starting_stats.defense
	speed = starting_stats.speed
	damage_mod = starting_stats.damage_mod
	haste = starting_stats.haste

	hp = max_hp
	mana = max_mana
	speed_vector = Vector2(speed, speed)
	for skill in skills:
		$Skills.add_child(skill.instance())

func get_skills() -> Array:
	return $Skills.get_children()

func take_damage(amount : int) -> void:
	var damage := amount - amount * float(defense) / 100.0
	print(str(self) + " took " + str(damage) + " damage!")
	hp = max(hp - damage, 0)
	emit_signal("health_changed", hp)
	if hp == 0:
		emit_signal("died")

func blood_explode(dir : Vector2) -> void:
	var blood = blood_particles.instance()
	blood.position = position
	blood.modulate = team_color
	blood.rotation = Vector2.RIGHT.angle_to(dir)
	get_parent().add_child(blood)

func use_mana(amount : int) -> void:
	mana = max(0, mana - amount)
	if mana == 0:
		$ManaRegen.start()

func heal(amount : int) -> void:
	hp = min(hp + amount, max_hp)
	emit_signal("health_changed", hp)

func set_max_hp(new_hp : int) -> void:
	max_hp = max(new_hp, 0)

func set_max_mana(new_mana : int) -> void:
	max_mana = max(new_mana, 0)


func _on_ManaRegen_timeout():
	mana = max_mana


func _on_Character_died():
	dead = true
	queue_free()
