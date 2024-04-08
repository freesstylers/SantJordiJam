extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var direction = -1
@export var horizontalSpeed = 50
@export var detect_cliffs = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var Player

func _ready():
	Player = get_parent().get_parent().get_node("Player")

var angle_to_player
var launching = false
@export var launchSpeed = 5

func _physics_process(delta):
	if $player_checker.is_colliding():
		launching = true
	else:
		launching = false

	if not launching:
		$player_checker.target_position.move_toward(Player.position, 0.1)
		angle_to_player = global_position.direction_to(Player.position).angle()
		rotation = move_toward(rotation, angle_to_player, delta)
	else:
		position.x = move_toward(position.x, Player.position.x, 0.5 * launchSpeed)
		position.y = move_toward(position.y, Player.position.y, 0.5 * launchSpeed)
	
	move_and_slide()
