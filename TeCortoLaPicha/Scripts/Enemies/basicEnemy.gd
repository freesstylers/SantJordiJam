extends baseEnemy

class_name  basic_enemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var direction = -1
@export var horizontalSpeed = 50
@export var detect_cliffs = true

@export var damageToCharacter: int = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#func _ready():
	#pass
	#$floor_checker.position.x = $CollisionShape2D.shape.get_rect().position.x * -direction
	#$floor_checker.enabled = detect_cliffs
	
func _physics_process(delta):

	if current_move_buffer > 0:
		current_move_buffer -= delta
	
	# Add the gravity.	
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_wall() or (not $floor_checker.is_colliding() && is_on_floor()):
		direction *= -1
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_rect().position.x * -direction
	
	if current_move_buffer <= 0:
		velocity.x = horizontalSpeed * direction		 

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name == "Player" and not dead:
		body.characterTakeLife(damageToCharacter, position)
	pass # Replace with function body.

func changeWormAnim(anim):
	match anim:
		0:
			$AnimatedSprite2D.set_animation("caperucita")
		1:
			$AnimatedSprite2D.set_animation("hatsune")
		2: 
			$AnimatedSprite2D.set_animation("jorgemadresalvajewild")
		3:
			$AnimatedSprite2D.set_animation("quijote")
		4:
			$AnimatedSprite2D.set_animation("marx")
		#5:
			#$AnimatedSprite2D.set_anim("Marx")
