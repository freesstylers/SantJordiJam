extends CharacterBody2D
class_name Player

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descend : float

@export var border_jump_height : float
@export var border_jump_time_to_peak : float
@export var border_jump_time_to_descend : float

var jump_velocity : float
var jump_gravity : float
var fall_gravity : float

var border_jump_velocity
var border_jump_gravity
var border_fall_gravity

@export var labelText : Label
@export var animationPlayer : AnimatedSprite2D
@export var leftRaycast : RayCast2D
@export var rightRaycast : RayCast2D
@export var leftFootRaycast : RayCast2D
@export var rightFootRaycast : RayCast2D
@export var max_speed : float = 1000.0
@export var max_sprinting_speed : float = 2500.0
@export var acceleration : float = 50

var act_max_speed : float = 0

@export var jump_buffer_time : float = 0.2
var jump_buffer_counter : float = 0

@export var coyote_time : float = 0.2
var coyote_counter : float = 0.0

#Dashing
@export var DashSpeed = 500000
var dashing = false
@export var dashDuration: float = 0.8
var auxDashTime : float = 0.0
@export var dashCooldown: float = 3.0
var auxDashCooldown = 0.0
var canDash = true

var flying_vel : Vector2 = Vector2(0,0)

func _ready():
	jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1
	jump_gravity  = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
	fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend)) * -1
	
	border_jump_velocity = ((2.0 * border_jump_height) / border_jump_time_to_peak) * -1
	border_jump_gravity = ((-2.0 * border_jump_height) / (border_jump_time_to_peak * border_jump_time_to_peak)) * -1
	border_fall_gravity = ((-2.0 * border_jump_height) / (border_jump_time_to_descend * border_jump_time_to_descend)) * -1
	
func get_gravity() -> float:
	#if ((rightFootRaycast.is_colliding() and not rightRaycast.is_colliding()) and 
	#(rightFootRaycast.is_colliding() and not rightRaycast.is_colliding())):
	#	return border_jump_gravity #  if velocity.y < 0.0 else fall_gravity
	#else:
		return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity

func jump_border():
	velocity.y = border_jump_velocity

func _physics_process(delta):
	print(velocity)
	# VERTICAL MOVEMENT CONTROL
	if not is_on_floor():
		velocity.y += ((get_gravity() * delta)+flying_vel.y)
		if coyote_counter > 0.0:
			coyote_counter -= delta
		if velocity.y < 0:
			animationPlayer.play("Jump")
		elif velocity.y > 0 and !is_on_floor():
			animationPlayer.play("Fall")	
	else:
		coyote_counter = coyote_time
			
	####### INPUT
	# JUMP INPUT
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_counter = jump_buffer_time	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= delta
	if jump_buffer_counter > 0 and coyote_counter > 0:
		jump() 
		jump_buffer_counter = 0
		coyote_counter = 0
	if Input.is_action_just_released("ui_accept"):
		if velocity.y < 0:
			velocity.y += 150
	# MOVEMENT INPUT
	act_max_speed = max_speed
	if Input.is_action_pressed("RTrigger"):
		act_max_speed = max_sprinting_speed
	var direction = Input.get_axis("ui_left", "ui_right")
	if Input.get_action_strength("ui_left") > 0.05 and not leftRaycast.is_colliding():
		animationPlayer.scale.x = abs(animationPlayer.scale.x) * -1
	elif Input.get_action_strength("ui_right") > 0.05 and not rightRaycast.is_colliding():
		animationPlayer.scale.x = abs(animationPlayer.scale.x)
	else:
		pass
		#Goes to 0 if not pressing anything in 0.2 seconds
		#velocity.x = lerp(velocity.x, 0.0, 0.2)
	
	#######Dash	
	if Input.is_action_just_pressed("Dash") and canDash:
		dashing = true
		canDash = false		
	if dashing:
		auxDashTime += delta	
		if auxDashTime >= dashDuration:
			dashing = false
			auxDashTime = 0.0
			auxDashCooldown = 0.0
	elif not canDash:
		auxDashCooldown += delta
		if auxDashCooldown >= dashCooldown:
			canDash = true
	if dashing:
		velocity.x = move_toward(velocity.x, direction * DashSpeed, acceleration * delta) + flying_vel.x
	else:
		velocity.x = move_toward(velocity.x, direction * act_max_speed, acceleration * delta) + flying_vel.x
		
	#######Anim hangling
	if is_on_floor() and (velocity.x <= -3.0 or velocity.x >= 3.0):
		if Input.is_action_pressed("RTrigger"):
			animationPlayer.play("Run_Fast")
		else: 
			animationPlayer.play("Run")
	else:
		if is_on_floor():
			animationPlayer.play("Idle")
			
	#######Move and simulate collisions
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Door":
			Globals.doorAttempt.emit()

func Launch(launch_vel):
	velocity = launch_vel
	flying_vel = launch_vel
	var local_tween = create_tween()
	local_tween.tween_property(self, "flying_vel", Vector2(0,0), 0.2)
