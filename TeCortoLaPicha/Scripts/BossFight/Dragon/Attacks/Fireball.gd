extends Node2D
class_name Fireball

@export var rotationSpeed : float = 180
@export var max_life_time_timer : Timer = null
@export var Damage : int = 1

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
	if other.is_in_group("player"):
		collided = true
		(other as Player).characterTakeLife(Damage, global_position)

func Destroy():
	queue_free()
