extends Area2D

@onready var anim = $AnimationPlayer
@export var damage : int = 1

func attack():
	anim.play("swing")


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
