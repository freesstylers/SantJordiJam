extends CharacterBody2D

@export var speed = 200
var direction = 1
var shot = false
var Player


func _ready():
	pass
	
func _physics_process(delta):

	velocity.x = direction * speed
	
	move_and_slide()
	
	detectCollisions()

func detectCollisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is Player:
			pass
		queue_free()
