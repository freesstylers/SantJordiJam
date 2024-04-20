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
@export var animationPlayer : AnimationPlayer
@export var sprite : Sprite2D
@export var leftRaycast : RayCast2D
@export var rightRaycast : RayCast2D
@export var leftFootRaycast : RayCast2D
@export var rightFootRaycast : RayCast2D
@export var max_speed : float = 1000.0
@export var max_sprinting_speed : float = 2500.0
@export var acceleration : float = 50

var act_max_speed : float = 0

@export var double_press_buffer : float = 0.3
var double_press_counter : float = 0
var double_tap = false
var tap_right = false
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

@export var damage : int = 20
@export var characterLife : int = 15 #Time + Life
@export var damageForceX = 50
@export var damageForceY = 50
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

func _input(event):
	if (!dashing and !attacking):
		ControlDoubleTap(get_physics_process_delta_time(), direction, event)
		
	if Input.is_action_just_pressed("Attack"):
		animationPlayer.play("witiza_attack_anim")
		attacking = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "witiza_attack_anim":
		attacking = false
		print("end attack")
	pass # Replace with function body.

var attacking = false

var direction
func _physics_process(delta):

	# VERTICAL MOVEMENT CONTROL
	if not is_on_floor() and !dashing and !attacking:
		velocity.y += ((get_gravity() * delta)+flying_vel.y)
		if coyote_counter > 0.0:
			coyote_counter -= delta
		if velocity.y < 0:
			animationPlayer.play("witiza_jump_anim")
		elif velocity.y > 0 and !is_on_floor():
			animationPlayer.play("witiza_fall_anim")	
	else:
		coyote_counter = coyote_time
		velocity.y = 0
	
	#INPUT MANAGEMENT 
	
	direction = Input.get_axis("ui_left", "ui_right")
	if (!dashing and !attacking):
		# JUMP INPUT
		if Input.is_action_just_pressed("Jump"):
			jump_buffer_counter = jump_buffer_time	
		if jump_buffer_counter > 0:
			jump_buffer_counter -= delta
		if jump_buffer_counter > 0 and coyote_counter > 0:
			jump() 
			jump_buffer_counter = 0
			coyote_counter = 0
		if Input.is_action_just_released("Jump"):
			if velocity.y < 0:
				velocity.y += 70
		# ANIM FLIP
		act_max_speed = max_speed
		if Input.is_action_pressed("RTrigger"):
			act_max_speed = max_sprinting_speed
		
		if Input.get_action_strength("ui_left") > 0.05 and not leftRaycast.is_colliding():
			sprite.flip_h = true
		elif Input.get_action_strength("ui_right") > 0.05 and not rightRaycast.is_colliding():
			sprite.flip_h = false
		else:
			pass
			#Goes to 0 if not pressing anything in 0.2 seconds
			#velocity.x = lerp(velocity.x, 0.0, 0.2)
		
	ControlDash(delta, direction)
		
	#######Anim handling
	if(!dashing and !attacking):
		if is_on_floor() and (velocity.x <= -3.0 or velocity.x >= 3.0):
			if Input.is_action_pressed("RTrigger"):
				animationPlayer.play("witiza_run_anim")
			else: 
				animationPlayer.play("witiza_walk_anim")
		else:
			if is_on_floor():
				animationPlayer.play("witiza_idle_anim")
			
	#######Move and simulate collisions
	
	double_press_counter -= delta
	
	if double_press_counter <= 0:
		double_tap = false
		
	if(dashing):
		act_max_speed = DashSpeed
		
	velocity.x = move_toward(velocity.x, direction * act_max_speed, acceleration * delta) + flying_vel.x
	
	if !attacking:
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

func ControlDoubleTap(_delta, direction, event_):
	var currenTapRight = false

	if event_ is InputEventKey:
		if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right"):
			if Input.is_action_just_pressed("ui_right"):
				currenTapRight = true
			else:
				currenTapRight = false
				
			if double_press_counter > 0 and tap_right == currenTapRight:
				double_tap = true
				print("DOUBLE TAP")
			
			elif double_press_counter <= 0:
				double_press_counter = double_press_buffer
				
			tap_right = currenTapRight
	elif event_ is InputEventJoypadButton:
		if Input.is_action_just_pressed("Dash"):
			if direction != 0:
				double_tap = true
		pass	
		
	
		
func ControlDash(delta, direction):
	#######Dash	
	if double_tap and canDash:
		dashing = true
		canDash = false
		animationPlayer.play("witiza_dash_anim")
		act_max_speed = DashSpeed	
		velocity.x = direction * DashSpeed
			
	if dashing:
		auxDashTime += delta	
		if auxDashTime >= dashDuration:
			dashing = false
			auxDashTime = 0.0
			auxDashCooldown = 0.0
			
	elif not canDash:
		auxDashCooldown += delta
		if auxDashCooldown >= dashCooldown and is_on_floor():
			canDash = true


func _on_sword_collider_body_entered(body):
	print("te pegue")
	body.takeDamage(damage)
	body.applyForce(position)
	pass # Replace with function body.

func characterTakeLife(value, enemy):
	characterLife -= value
	applyForce(enemy)
	print(characterLife)
	
	if characterLife <= 0:
		#@Javi aqui pantalla de muerte
		pass
		
func applyForce(enemy):
	var dir = clamp(position.x - enemy.x, -1, 1)
	velocity.x += dir * damageForceX
	velocity.y -= damageForceY
