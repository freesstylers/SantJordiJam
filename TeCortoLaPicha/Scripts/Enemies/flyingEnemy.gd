extends baseEnemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var direction = -1
@export var horizontalSpeed = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$wall_checker.target_position.x *= -direction

var time = 0
var freq = 3
var amplitude = 20

func _physics_process(delta):

	if is_on_wall() or $wall_checker.is_colliding():
		direction *= -1
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
		$wall_checker.target_position.x *= -direction

	time += delta
	velocity.x = horizontalSpeed * direction		 
	velocity.y = sin(PI/2 + time*freq)*amplitude

	move_and_slide()
