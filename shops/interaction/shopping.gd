extends Area2D
class_name shopping

@export var action_name: String = "Buy"

var Buy: Callable = func():
	pass
	
	


func _on_body_entered(body: Node2D) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)
