extends Area2D
class_name shopping

@export var action_name: String = "Buy"
@export var shop_cost: int = 0

var Buy: Callable = func():
	pass
	
	

# when body entered or exited signals interactin manager

func _on_body_entered(body: Node2D) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)
