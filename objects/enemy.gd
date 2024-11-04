extends CharacterBody2D


const SPEED = 250
const SLOW_SPEED = 75
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
var hurt = false


#Zombie Noises
@onready var moan_1 = $Zombie_moan_1
@onready var moan_2 = $Zombie_moan_2
@onready var moan_3 = $Zombie_moan_3

@onready var moan_manager = [moan_1, moan_2, moan_3]


@onready var zombie_bite = $Zombie_bite

signal step


func canSpawn(point_):
	return not point_.show_behind_parent


func setup(zone_, point_):
	zone = zone_
	point = point_
	
	point_.show_behind_parent = true
	
	health = 3 * (zone_ + 1)
	
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

func hurt_animate(speed):
	print("blah")
	if speed < 0.1:
		$Sprite.play("hurt_default")
		return
		
	if velocity.x > 0:
		$Sprite.flip_h = true
		$Sprite.play("hurt_west", speed)
		return
	
	$Sprite.flip_h = false
	
	if velocity.x < 0:
		$Sprite.play("hurt_west", speed)
		return
	
	if velocity.y > 0:
		$Sprite.play("hurt_default", speed)
		return
	
	if velocity.y < 0:
		$Sprite.play("hurt_north", speed)
		return

func _process(_delta: float) -> void:
	if hurt == true:
		hurt_animate(2)
	else: 
		animate(1)


func die():
	if Currencies.zone == zone:
		Currencies.money.add(2 * (5 ** zone))

	if point:
		point.show_behind_parent = false
	
	queue_free()


func handle_hit(damage: int):
	health -= damage
	print("Enemy was hit " + str(health))
	hurt = true
	await get_tree().create_timer(.5).timeout
	hurt = false
	
	if health <= 0:
		die()


func onCollide(collision):
	velocity = velocity.bounce(collision.get_normal())
	
	var body = collision.get_collider()
	if body is Player and Time.get_unix_time_from_system() - lastHitPlayer > 0.5:
		lastHitPlayer = Time.get_unix_time_from_system()
		zombie_bite.play()
		body.takeDamage(zone + 1)


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
		#random zombie moans
		play_sound()
		return true
	
	var move = lastSeenPlayer - position
	if Currencies.zone != zone:
		wander()
		return true
	
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


func play_sound():
	var rand_index : int  = randi_range(0, moan_manager.size() - 1)
		# coin flip for sound to play
	if randi()%2 == 0:
		moan_manager[rand_index].play()
		await get_tree().create_timer(4).timeout
 

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

func _on_bullet_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("_on_visible_on_screen_enabler_2d_screen_exited"):
		handle_hit(body.damage)
	body.queue_free()
	
