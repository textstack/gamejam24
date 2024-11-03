extends RigidBody2D

var velocity = Vector2(0,0)
var speed = 300
var damage = 4

func _physics_process(delta: float) -> void:
	
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	self.queue_free()
	
