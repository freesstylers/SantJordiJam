extends baseEnemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var direction = -1
@export var horizontalSpeed = 50.0
@export var detect_cliffs = true
@export var player_detector : RayCast2D
@export var damageToCharacter: int = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var charge_velocity = 400
@export var decelration = 100
@export var wait_before_charge = 0.5
@export var charge_time = 1.2

var charge_time_buffer = 0
var waiting_buffer = 0
var charging = false

var yPosition = 0
#func _ready():
	#$floor_checker.position.x = $CollisionShape2D.shape.get_rect().position.x * -direction
	#$floor_checker.enabled = detect_cliffs
	
func _physics_process(delta):

	if current_move_buffer > 0:
		current_move_buffer -= delta
	
	if is_on_floor():
		if !charging:
			if player_detector.is_colliding() and waiting_buffer <= 0:
				if player_detector.get_collider().is_in_group("player"):
					waiting_buffer = wait_before_charge
					velocity.x = 0.0
					
			if waiting_buffer > 0:
				waiting_buffer -= delta
				if waiting_buffer <= 0:
					charge()
		else:		
			charge_time_buffer -= delta
			position.y = yPosition
			if charge_time_buffer <= 0:
				charging = false
				charge_time_buffer = 0
				
	# Add the gravity.	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	elif is_on_wall(): #or (detect_cliffs and not $floor_checker.is_colliding()):
		direction *= -1
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
		player_detector.target_position.x = -player_detector.target_position.x
		#$floor_checker.position.x = $CollisionShape2D.shape.get_rect().position.x * -direction
	
	if !charging and waiting_buffer <= 0:
		velocity.x = lerp(velocity.x, horizontalSpeed * float(direction), decelration * delta)

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.characterTakeLife(damageToCharacter, position)
	pass # Replace with function body.
	
func charge():
	velocity.x = charge_velocity * direction
	charge_time_buffer = charge_time
	charging = true
	yPosition = position.y
