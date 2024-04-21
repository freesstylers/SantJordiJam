extends baseEnemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var direction = -1
@export var horizontalSpeed = 50
@export var detect_cliffs = true
@export var sprite : AnimatedSprite2D
@export var instantationOffsett = Vector2(20, 2)
@export var bullet: PackedScene
@export var shootingTime: float = 3.0
@export var cooldown = 3.0
@export var damageToCharacter: int = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var Player
var angle_to_player
var shooting = false

var auxShootingTime = 0.0
var timeSinceCooldown = 0.0

var timesShot = 0
var lookingRight = true
var lastDir = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	Player = get_parent().get_parent().get_node("Player")
func _process(delta):
	
	if current_move_buffer > 0:
		current_move_buffer -= delta
		
	if not $floor_checker.is_colliding() and not Player == null:
		$floor_checker.target_position.move_toward(Player.position, 0.01)
		angle_to_player = global_position.direction_to(Player.position).angle()
		#rotation = move_toward(rotation, angle_to_player, delta)
	if not shooting: #No restart
		sprite.play("default")
		timeSinceCooldown += delta
		
		flip()
				
		if timeSinceCooldown > cooldown:
			shooting = true
			sprite.play("Attack")
		

		
	if shooting:
		auxShootingTime += delta
	
		if auxShootingTime > sprite.animation.length()/6:
			shoot()
			auxShootingTime = 0
			timesShot += 1
			
			if timesShot > 2:
				shooting = false
				timesShot = 0
				auxShootingTime = 0	
				timeSinceCooldown = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _physics_process(delta):
	lerp(velocity.x, 0.0, 300 * delta)
		
func shoot():
	var bulletAux = bullet.instantiate()
	bulletAux.position = position + Vector2(instantationOffsett.x * -lastDir, instantationOffsett.y)
	bulletAux.Player = Player
	bulletAux.shot = true
	bulletAux.direction = -lastDir
	get_parent().add_child((bulletAux))
	
func flip():
	if Player != null:
		var dir = position.x - Player.position.x
		if dir > 0:
			lookingRight = true
		else:
			lookingRight = false
		
		if lookingRight && lastDir < 0 || !lookingRight && lastDir > 0:
			$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
			
		lastDir = clamp(dir, -1, 1)


func _on_area_2d_body_entered(body):
	if body.name == "Player" and not dead:
		body.characterTakeLife(damageToCharacter, position)
	pass # Replace with function body.
	pass # Replace with function body.
