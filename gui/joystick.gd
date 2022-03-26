tool
extends Node2D

signal joystick_moved(dir)

const NO_INPUT : int = -1

export var available_radius : int = 32
export var button_radius : int = 8
export var search_radius : int = 128 setget set_search_radius

onready var button := get_node("InnerCircle")

var joystick_active : bool = false
var current_index := NO_INPUT


func _input(event : InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if in_search_area(event) or joystick_active:
			if current_index == NO_INPUT:
				current_index = event.get_index()
			elif current_index != event.get_index():
				return
			button.global_position = event.position - Vector2(button_radius, button_radius)
			joystick_active = true
		if event is InputEventScreenTouch:
			if not event.is_pressed():
				button.position = Vector2.ZERO
				emit_signal("joystick_moved", Vector2.ZERO)
				joystick_active = false
				current_index = NO_INPUT
		if button.position.length() > available_radius:
			var reduce : float = available_radius / button.position.length()
			button.position *= reduce


func _process(_delta) -> void:
	$IndexLabel.text = str(current_index)
	if joystick_active:
		emit_signal("joystick_moved", calculate_move_vector())
	if Engine.editor_hint:
		self.search_radius = search_radius

func calculate_move_vector() -> Vector2:
	return (button.global_position - self.position).normalized()

func in_search_area(event : InputEvent) -> bool:
	var vec = event.position - $Center.global_position
	if event.get_index() == current_index:
		$RayCast2D.cast_to = vec * 2 / (scale.x + scale.y)
	return vec.length() <= search_radius * (scale.x + scale.y) / 2

func set_search_radius(new_radius : int) -> void:
	search_radius = new_radius
	if not get_node_or_null("SearchAreaPreview"):
		return
	$SearchAreaPreview.scale.x = float(new_radius) / 32 
	$SearchAreaPreview.scale.y = float(new_radius) / 32 
