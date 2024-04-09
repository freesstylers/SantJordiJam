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
	auxLaunchCooldown = launchingCooldown
	
var angle_to_player
var launching = false
@export var launchSpeed = 5
@export var launchingCooldown : float = 5.0
@export var launchingMaxTime : float = 5.0
var auxLaunchCooldown = 0
var auxLaunching = 0
#var targetPos : Vector2

func _physics_process(delta):
	if $player_checker.is_colliding() and not launching and auxLaunchCooldown > launchingCooldown:
		launching = true
		auxLaunching = 0.0
		print ("Start Launch")
		#targetPos = Player.position
		
	if not launching:
		$player_checker.target_position.move_toward(Player.position, 0.1)
		angle_to_player = global_position.direction_to(Player.position).angle()
		rotation = move_toward(rotation, angle_to_player, delta)
		auxLaunchCooldown += delta
	elif auxLaunching < launchingMaxTime:
		position.x = move_toward(position.x, Player.position.x, 0.5 * launchSpeed)
		position.y = move_toward(position.y, Player.position.y, 0.5 * launchSpeed)
		auxLaunching += delta
	else:
		print("launch ended")
		auxLaunchCooldown = 0.0
		launching = false
		
	move_and_slide()
