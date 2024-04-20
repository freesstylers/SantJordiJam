extends CharacterBody2D

@export var speed = 200
var direction = 1
var shot = false
var Player
@export var damageToCharacter: int = 1

func _ready():
	pass
	
func _physics_process(delta):

	velocity.x = direction * speed
	
	move_and_slide()
	
	#detectCollisions()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.characterTakeLife(damageToCharacter, position)
		
	queue_free()
	pass # Replace with function body.
