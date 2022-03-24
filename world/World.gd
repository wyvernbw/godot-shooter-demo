extends Node2D

export var enemies : Array

onready var spawn_points : Array

func _ready() -> void:
	spawn_points = $SpawnPositions.get_children()

func _on_SpawnTimer_timeout():
	enemies.shuffle()
	var enemy_instance = enemies.front().instance()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pos_index = rng.randi_range(0, spawn_points.size() - 1)
	enemy_instance.position = spawn_points[pos_index].position
	add_child(enemy_instance)
