extends CharacterBody2D


var target
var othersNear = {}


const SPEED = 200
const SLOW_SPEED = 50
const SMOOTH = 0.05


var lastHitPlayer = 0


func die():
	queue_free()


func onCollide(collision):
	velocity = velocity.bounce(collision.get_normal())
	
	var body = collision.get_collider()
	if body is Player and Time.get_unix_time_from_system() - lastHitPlayer > 0.5:
		lastHitPlayer = Time.get_unix_time_from_system()
		body.takeDamage(10 ** Currencies.zone)


func goTowardsTarget():
	if not target or Currencies.zone < 0:
		velocity = velocity.lerp(Vector2(), SMOOTH)
		return
	
	var diff = target.position - position
	var dot = target.velocity.normalized().dot(-diff.normalized())
	var move = diff + target.velocity * (1 - dot)
	velocity = velocity.lerp(move.normalized() * SPEED, SMOOTH)
	
	$RichTextLabel.text = str(move)


func goAwayFromOthers():
	var totalDiff = Vector2()
	for dudeID in othersNear:
		var dude = instance_from_id(dudeID)
		if not dude:
			continue
		
		totalDiff += dude.position - position
	
	velocity = velocity.lerp(totalDiff.normalized() * -SLOW_SPEED, SMOOTH)


func _physics_process(delta: float) -> void:
	var collision = get_last_slide_collision()
	if collision:
		onCollide(collision)
	
	goAwayFromOthers()
	goTowardsTarget()
	move_and_slide()


func _on_sight_body_entered(body: Node2D) -> void:
	if body.is_in_group("Trackable"):
		target = body


func _on_sight_body_exited(body: Node2D) -> void:
	if body == target:
		target = null


func _on_move_away_body_entered(body: Node2D) -> void:
	if body != self and body.is_in_group("TrackingEnemy"):
		othersNear[body.get_instance_id()] = true


func _on_move_away_body_exited(body: Node2D) -> void:
	if body.is_in_group("TrackingEnemy"):
		othersNear.erase(body.get_instance_id())
