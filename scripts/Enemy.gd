extends KinematicBody2D

var linear_vel = Vector2.ZERO

var GRAVITY = 400
var MAX_SPEED = 300
var DEACCELERATION = 100
var VISION_RANGE = 340

var Bullet = preload("res://scenes/Bullet.tscn")

var _facing_right = true

export(NodePath) var target
onready var _target = get_node(target) as Node2D

onready var playback = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	$FireTimer.connect("timeout", self, "on_timeout")
	$AnimationTree.active = true

func _physics_process(delta: float) -> void:
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	linear_vel.y += GRAVITY * delta
	
	linear_vel.x = move_toward(linear_vel.x, 0, DEACCELERATION)
	
	if _target:
		if _target.global_position.x < global_position.x and _facing_right:
			scale.x = -1
			_facing_right = false
		if _target.global_position.x > global_position.x and not _facing_right:
			scale.x = -1
			_facing_right = true

func fire():
	var bullet = Bullet.instance()
	bullet.global_position = $BulletSpawn.global_position
	if not _facing_right:
		bullet.rotation = PI
	get_parent().add_child(bullet)
	linear_vel.x = (-1 if _facing_right else 1) * MAX_SPEED * 3

func on_timeout():
	$FireTimer.wait_time = rand_range(2, 5)
	if abs(_target.global_position.x -  global_position.x) > VISION_RANGE:
			return
	playback.travel("attack")

func take_damage(instigator: Node2D):
	linear_vel.x = sign(global_position.x - instigator.global_position.x) * MAX_SPEED * 3
