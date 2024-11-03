extends CharacterBody2D


const SPEED = 300
const SLOW_SPEED = 50
const SMOOTH = 0.05

var health = 2

var thinSprite = preload("res://objects/thinsprite.tres")
var kidSprite = preload("res://objects/kidsprite.tres")
var bigSprite = preload("res://objects/bigsprite.tres")

var target
var othersNear = {}
var lastHitPlayer = 0
var lastSeenPlayer
var point
var zone = 0
var doWander = false
var wanderVel
var wanderCurl


func setup(zone_, point_):
	zone = zone_
	point = point_
	
	health = 2 * zone
	
	if zone == 0:
		$Sprite.sprite_frames = kidSprite
	elif zone == 1:
		$Sprite.sprite_frames = thinSprite
	elif zone == 2:
		$Sprite.sprite_frames = bigSprite


func animate(speed):
	if speed < 0.1:
		$Sprite.play("default")
		return
	
	var minSp = speed * 40
	
	if velocity.length() <= minSp:
		animate(speed / 2.0)
		return
		
	if velocity.x > minSp:
		$Sprite.flip_h = true
		$Sprite.play("walk_west", speed)
		return
	
	$Sprite.flip_h = false
	
	if velocity.x < -minSp:
		$Sprite.play("walk_west", speed)
		return
	
	if velocity.y > minSp:
		$Sprite.play("walk_south", speed)
		return
	
	if velocity.y < -minSp:
		$Sprite.play("walk_north", speed)
		return


func _process(_delta: float) -> void:
	animate(1)


func die():
	Currencies.money.add(5 ** zone)
	if point:
		point.visible = true
	queue_free()


func handle_hit(damage: int):
	health -= damage
	print("Enemy was hit " + str(health))
	if health <= 0:
		die()


func onCollide(collision):
	velocity = velocity.bounce(collision.get_normal())
	
	var body = collision.get_collider()
	if body is Player and Time.get_unix_time_from_system() - lastHitPlayer > 0.5:
		lastHitPlayer = Time.get_unix_time_from_system()
		body.takeDamage(10 ** zone)


func wander():
	var move = Vector2()
	if doWander:
		if not wanderVel:
			wanderVel = Vector2(randf_range(-1, 1), randf_range(-1, 1))
			wanderCurl = randf_range(-0.02, 0.02)
		move = wanderVel
		
		wanderVel = wanderVel.rotated(wanderCurl)
	elif wanderVel:
		wanderVel = null
	
	velocity = velocity.lerp(move * SLOW_SPEED, SMOOTH)


func goTowardsLastSeen():
	if target:
		$CanSeePlayer.target_position = target.position - position
		
		if $CanSeePlayer.get_collider() == target:
			lastSeenPlayer = target.position
			return false
	
	if not lastSeenPlayer:
		return true
	
	var move = lastSeenPlayer - position
	if move.length() < 40:
		wander()
		return true
	
	velocity = velocity.lerp(move.normalized() * SPEED, SMOOTH)
	return true


func goTowardsTarget():
	if Currencies.zone < 0:
		lastSeenPlayer = null
		wander()
		return
	
	if goTowardsLastSeen():
		return
		
	if not target:
		wander()
		return
	
	if point:
		point.visible = true
	
	var diff = target.position - position
	var dot = target.velocity.normalized().dot(-diff.normalized())
	var move = diff + target.velocity * (1 - dot)
	velocity = velocity.lerp(move.normalized() * SPEED, SMOOTH)


func goAwayFromOthers():
	var totalDiff = Vector2()
	for dudeID in othersNear:
		var dude = instance_from_id(dudeID)
		if not dude:
			continue
		
		totalDiff += dude.position - position
	
	velocity = velocity.lerp(totalDiff.normalized() * -SLOW_SPEED, SMOOTH)


func _physics_process(_delta: float) -> void:
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


func _on_wander_timer_timeout() -> void:
	doWander = not doWander
	$WanderTimer.wait_time = randf_range(1.5, 3)
