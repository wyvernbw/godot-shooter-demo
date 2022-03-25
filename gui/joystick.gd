tool
extends Node2D

signal joystick_moved(dir)

export var available_radius : int = 32
export var button_radius : int = 8
export var search_radius : int = 128 setget set_search_radius

onready var button := get_node("TouchScreenButton")

var joystick_active : bool = false


func _input(event : InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if in_search_area(event.position) or joystick_active:
			button.global_position = event.position - Vector2(button_radius, button_radius)
			joystick_active = true
		if event is InputEventScreenTouch:
			if not event.is_pressed():
				button.position = Vector2.ZERO
				joystick_active = false
		if button.position.length() > available_radius:
			var reduce : float = available_radius / button.position.length()
			button.position *= reduce


func _process(_delta) -> void:
	if joystick_active:
		emit_signal("joystick_moved", calculate_move_vector())
	if Engine.editor_hint:
		self.search_radius = search_radius

func calculate_move_vector() -> Vector2:
	return (button.global_position - self.position).normalized()

func in_search_area(pos : Vector2) -> bool:
	var length = ($Center.position - pos).length()
	return length <= search_radius * (scale.x + scale.y) / 2

func set_search_radius(new_radius : int) -> void:
	search_radius = new_radius
	if not get_node_or_null("SearchAreaPreview"):
		return
	$SearchAreaPreview.scale.x = float(new_radius) / 32 
	$SearchAreaPreview.scale.y = float(new_radius) / 32 
