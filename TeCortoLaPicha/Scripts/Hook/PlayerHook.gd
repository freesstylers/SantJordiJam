extends Node2D
class_name PlayerHook
@onready var rope_starting_point : Sprite2D = $RopeStartingPoint
@onready var grappling_rope : GrapplingRope = $RopeStartingPoint/Rope
@onready var ray : RayCast2D = $RopeStartingPoint/RayCast2D
@export var ImpulseSound : AudioStreamPlayer2D = null

@export var body_to_launch : PhysicsBody2D = null
@export var launch : bool = false
@export var launch_duration : float = 0.35
@export var rope_length : float = 400
@export var launch_impulse_force : float = 75

var hook_shot = false
var hook_target_pos : Vector2 = Vector2.ZERO
var hook_target_object : HookTarget = null
var movement_tween : Tween = null

func _ready():
	($RopeStartingPoint/RayCast2D as RayCast2D).target_position = Vector2(0,rope_length) 
	
func _process(_delta):
	var rope_end : Vector2 = Vector2(0,0)
	if launch:
		rope_end = hook_target_pos
		rope_starting_point.global_rotation = (rope_end-global_position).angle()
		return
	
	if not hook_shot:
		rope_end = get_global_mouse_position()
		if hook_target_object == null:
			if ray.is_colliding():
				var collider = ray.get_collider()
				if collider.is_in_group("hookable"):	
					hook_target_object = collider as HookTarget
					hook_target_object.update_target_status(true)
		elif hook_target_object != null:
			if not ray.is_colliding():
				hook_target_object.update_target_status(false)
				hook_target_object = null
	else:
		rope_end = hook_target_pos
	rope_starting_point.global_rotation = (rope_end-global_position).angle()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if not hook_shot and mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			if hook_target_object:
				hook_shot = true
				hook_target_object.play_anim_or_something()
				hook_target_pos = hook_target_object.global_position #ray.get_collision_point()
				rope_starting_point.global_rotation = (hook_target_object.global_position-global_position).angle()
				grappling_rope.ShootRope(hook_target_pos)
		elif hook_shot and mouse_event.button_index == MOUSE_BUTTON_RIGHT and not mouse_event.pressed:
			launch = false
			hook_shot = false
			hook_target_object = null
			grappling_rope.HideRope()
			if movement_tween != null:
				movement_tween.kill()
				movement_tween = null

#Make the player move towards the rope end and launch him into that direction
func Launch():
	launch = true
	var launch_impulse_dir = (hook_target_pos - global_position).normalized()
	movement_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	movement_tween.tween_property(body_to_launch, "position",hook_target_pos, launch_duration)
	movement_tween.tween_callback(func():
			launch = false
			grappling_rope.HideRope()
			hook_shot = false
			ImpulseSound.play()
			(body_to_launch as Player).Launch(launch_impulse_dir * launch_impulse_force)
			hook_target_object.update_target_status(false)
			hook_target_object = null
			movement_tween = null
			)
