extends Area2D
class_name Blast

export var speed : int
export var base_damage : int

var dir : Vector2 = Vector2.RIGHT
var damage : int = base_damage
var velocity := Vector2.ZERO

var target : Node

func _ready() -> void:
	$AnimationPlayer.play("appear")
	$Blast.modulate = target.team_color
	damage = base_damage * target.damage_mod

func _physics_process(delta : float):
	update_velocity()
	move_along(velocity, delta)
	rotation = Vector2.LEFT.angle_to(velocity)

func move_along(move : Vector2, delta : float) -> void:
	position += move * delta

func update_velocity() -> void:
	velocity += speed * dir 

func _on_Blast_body_entered(body : Node):
	if body.is_in_group("enemy") and target is Player: 
		body.take_damage(damage)
		body.blood_explode(velocity.normalized())


func _on_Notifier_screen_exited():
	queue_free()
