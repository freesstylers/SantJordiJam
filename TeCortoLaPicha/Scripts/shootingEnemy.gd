extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var direction = -1
@export var horizontalSpeed = 50
@export var detect_cliffs = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var Player
var angle_to_player
var shooting = false
@export var shootingTime: float = 3.0
var auxShootingTime = 0.0
var timesShot = 0
@export var bullet: PackedScene


func _ready():
	Player = get_parent().get_parent().get_node("Player")
	pass
	
func _process(delta):
	if not $floor_checker.is_colliding():
		$floor_checker.target_position.move_toward(Player.position, 0.01)
		angle_to_player = global_position.direction_to(Player.position).angle()
		rotation = move_toward(rotation, angle_to_player, delta)
	elif not shooting: #No restart
		shooting = true
		
	if shooting:
		auxShootingTime += delta
		
		if auxShootingTime > (shootingTime / 3):
			shoot()
			auxShootingTime = 0
			timesShot += 1
			
			if timesShot > 2:
				shooting = false
				timesShot = 0
				auxShootingTime = 0
			
		

func shoot():
	var bulletAux = bullet.instantiate()
	bulletAux.position = position
	bulletAux.Player = Player
	bulletAux.shot = true
	bulletAux.reparent(get_parent())
