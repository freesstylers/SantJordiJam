extends baseEnemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var direction = -1
@export var horizontalSpeed = 50
@export var detect_cliffs = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$floor_checker.position.x = $CollisionShape2D.shape.get_rect().position.x * -direction
	$floor_checker.enabled = detect_cliffs
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	elif is_on_wall() or (detect_cliffs and not $floor_checker.is_colliding()):
		direction *= -1
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_rect().position.x * -direction
			
	velocity.x = horizontalSpeed * direction		 

	move_and_slide()
