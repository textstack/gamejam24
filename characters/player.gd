extends CharacterBody2D

class_name Player


const SPEED = 250.0
const SMOOTH = 0.6
@export var knife = preload("res://weapons/knife.tscn")
@export var pipe = preload("res://weapons/pipe.tscn")
@export var pistol_bullet = preload("res://weapons/pistol_test.tscn")
@export var gun = preload("res://weapons/pistol.tscn")
@export var shotgun = preload("res://weapons/shotgun.tscn")
@export var shotGun_bullet = preload("res://weapons/shot_bul.tscn")

signal pistolB(bullet, velo, posit)

var cur_weapon = 0
var shoot_cooldown = true

# Weapon instanitations
var knife_equip
var pipe_equip
var pistol_equip
var shotgun_equip

#Animations
@onready var movement_ani = $AnimatedSprite2D

#Attack sounds
@onready var knife_sound = $knife_slash
@onready var pipe_sound = $pipe_hit
@onready var pistol_sound = $pistol_fire
@onready var shotgun_sound = $shotgun_fire

func takeDamage(amount):
	if not amount:
		amount = 1
	
	Currencies.health.total -= amount
	if Currencies.health.total <= 0:
		die()


func die():
	get_tree().quit()


func _process(_delta: float) -> void:
	if cur_weapon != Currencies.weapon_tier:
		cur_weapon = Currencies.weapon_tier
		if Currencies.weapon_tier == 1:
			print("now have knife")
			knife_equip = knife.instantiate()
			add_child(knife_equip)
		if Currencies.weapon_tier == 2:
			knife_equip.queue_free()
			print("now have pipe")
			pipe_equip = pipe.instantiate()
			add_child(pipe_equip)
		if Currencies.weapon_tier == 3:
			pipe_equip.queue_free()
			print("now have pistol")
			pistol_equip = gun.instantiate()
			add_child(pistol_equip)
		if Currencies.weapon_tier == 4:
			pistol_equip.queue_free()
			print("now have rifle")
			shotgun_equip = shotgun.instantiate()
			add_child(shotgun_equip)
		if Currencies.weapon_tier > 4:
			pass
			
	if Currencies.zone < 0:
		$HPTimer.wait_time = 2
		return
	
	$HPTimer.wait_time = 2.0 / (3 ** Currencies.zone)

func _physics_process(_delta: float) -> void:
	var move = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"),
	)
	
	var speed = SPEED + Upgrades.getSpeed() - Currencies.zone * 50
	velocity = velocity.lerp(move.normalized() * speed, SMOOTH)
	
	#Animation player for movement
	if Input.is_action_pressed("Down"):
		movement_ani.play("walk_down")
	elif Input.is_action_pressed("Up"):
		movement_ani.play("walk_up")
	elif Input.is_action_pressed("Right"):
		movement_ani.flip_h = false
		movement_ani.play("walk")
	elif Input.is_action_pressed("Left"):
		#flips animation horizontally
		movement_ani.flip_h = true
		movement_ani.play("walk")
	else:
		movement_ani.play("idle_face")
	
	move_and_slide()
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("attack") && (cur_weapon == 1):
		print("Knife attack")
		knife_sound.play()
		knife_equip.attack()
	elif Input.is_action_just_pressed("attack") && (cur_weapon == 2):
		print("Pipe attack")
		pipe_sound.play()
		pipe_equip.attack()
	elif Input.is_action_just_pressed("attack") && (cur_weapon == 3) && shoot_cooldown:
		print("Pistol attack")
		pistol_sound.play()
		shoot_cooldown = false
		var bullet_p = pistol_bullet.instantiate()
		bullet_p.rotation = $Marker2D.rotation
		var p_pos = pistol_equip.global_position
		var vel = mouse_pos - p_pos
		pistolB.emit(bullet_p, vel, p_pos)
		
		await get_tree().create_timer(1).timeout
		shoot_cooldown = true
		
	elif Input.is_action_just_pressed("attack") && (cur_weapon >= 4) && shoot_cooldown:
		print("ShotGun attack")
		shotgun_sound.play()
		shoot_cooldown = false
		var bullet_s = shotGun_bullet.instantiate()
		bullet_s.rotation = $Marker2D.rotation
		var p_pos = shotgun_equip.global_position
		var vel = mouse_pos - p_pos
		pistolB.emit(bullet_s, vel, p_pos)

		await get_tree().create_timer(1).timeout
		shoot_cooldown = true
	
	if Input.is_action_just_pressed("temp"):
		Currencies.weapon_tier += 1


func _on_hp_timer_timeout() -> void:
	if Currencies.zone < 0:
		return
	
	takeDamage(1)
	
