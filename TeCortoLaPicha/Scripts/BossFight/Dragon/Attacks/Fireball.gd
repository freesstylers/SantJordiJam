extends Node2D
class_name Fireball

@export var rotationSpeed : float = 180
@export var post_hit_timer : Timer = null
@export var max_life_time_timer : Timer = null

@onready var visualizer : Sprite2D = $FireballVisualizer
@onready var hit_sound : AudioStreamPlayer2D = $HitSound

var collided : bool = false
var direction = Vector2(1,0)
var speed = 0

func _process(delta):
	position += (direction * speed * delta)
	visualizer.rotation_degrees += (rotationSpeed * delta)

func shoot(dir, sp):
	max_life_time_timer.start()
	direction = dir.normalized()
	speed = sp

func on_body_entered(other):
	if collided:
		return
	collided = true
	post_hit_timer.start()

func Destroy():
	queue_free()
