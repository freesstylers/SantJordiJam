extends baseEnemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var direction = -1
@export var horizontalSpeed = 50
@export var damageToCharacter: int = 1
@export var wall_checker : RayCast2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	wall_checker.target_position.x *= -direction

var time = 0
var freq = 3
var amplitude = 20

func _physics_process(delta):
	if !dead:
		if current_move_buffer > 0:
			current_move_buffer -= delta
			
		if is_on_wall() or (wall_checker.is_colliding() and !wall_checker.get_collider().is_in_group("player")):
			direction *= -1
			$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
			$wall_checker.target_position.x *= -direction

		time += delta
		
		if(current_move_buffer <= 0):
			velocity.x = horizontalSpeed * direction		 
			velocity.y = sin(PI/2 + time*freq)*amplitude

		move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Player" and not dead:
		body.characterTakeLife(damageToCharacter, position)
	pass # Replace with function body.

func applyForce(player):
	var dir = clamp(position.x - player.x, -1, 1)
	velocity.x = dir * damageForceX
	current_move_buffer = canMoveCD
