extends CharacterBody2D

class_name Player


const SPEED = 250.0
const SMOOTH = 0.6
@export var knife = preload("res://weapons/knife.tscn")
@export var pipe = preload("res://weapons/pipe.tscn")
@export var pistol_bullet = preload("res://weapons/pistol_bullet.tscn")
@export var gun = preload("res://weapons/pistol.tscn")
@export var shotgun = preload("res://weapons/shotgun.tscn")
@export var shotGun_bullet = preload("res://weapons/shotGun_bullet.tscn")


var cur_weapon = 0
var shoot_cooldown = true

# Weapon instanitations
var knife_equip
var pipe_equip
var pistol_equip
var shotgun_equip


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
		if Currencies.weapon_tier >= 4:
			pipe_equip.queue_free()
			print("now have rifle")
			shotgun_equip = shotgun.instantiate()
			add_child(shotgun_equip)

func _physics_process(_delta: float) -> void:
	var move = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up"),
	)
	
	var speed = SPEED + Upgrades.speed * 50 - Currencies.zone * 50
	velocity = velocity.lerp(move.normalized() * speed, SMOOTH)
	
	move_and_slide()
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("attack") && (cur_weapon == 1):
		print("Knife attack")
		knife_equip.attack()
	elif Input.is_action_just_pressed("attack") && (cur_weapon == 2):
		print("Pipe attack")
		pipe_equip.attack()
	elif Input.is_action_just_pressed("attack") && (cur_weapon == 3) && shoot_cooldown:
		print("Pistol attack")
		shoot_cooldown = false
		var bullet_p = pistol_bullet.instantiate()
		bullet_p.rotation = $Marker2D.rotation
		bullet_p.global_position = $Marker2D.global_position
		add_child(bullet_p)
		
		await get_tree().create_timer(1).timeout
		shoot_cooldown = true


func _on_hp_timer_timeout() -> void:
	if Currencies.zone < 0:
		return
	
	takeDamage(5 ** Currencies.zone)
	
