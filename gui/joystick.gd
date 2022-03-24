extends Node2D

signal joystick_moved(dir)

export var available_radius : int = 32
export var button_radius : int = 8

onready var button := get_node("TouchScreenButton")

var in_search_area : bool = false
var joystick_active : bool = false

func _input(event : InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if in_search_area or joystick_active:
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


func calculate_move_vector() -> Vector2:
	return (button.global_position - self.position).normalized()


func _on_SearchZone_mouse_entered():
	in_search_area = true


func _on_SearchZone_mouse_exited():
	in_search_area = false
