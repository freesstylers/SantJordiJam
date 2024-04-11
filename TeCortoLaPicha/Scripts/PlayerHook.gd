extends RigidBody2D
class_name PlayerHook
@onready var rope_starting_point : Sprite2D = $RopeStartingPoint
@onready var grappling_rope : GrapplingRope = $RopeStartingPoint/Rope
@onready var ray : RayCast2D = $RopeStartingPoint/RayCast2D

@export var body_to_launch : PhysicsBody2D = null
@export var launch : bool = false
@export var launch_duration : float = 0.35
@export var launch_impulse : float = 100

var hook_shot = false
var hook_target : Vector2 = Vector2.ZERO

func _ready():
	set_process_input(true) # Enable input processing
	
func _process(delta):
	if launch:
		return
	
	var rope_end : Vector2 = Vector2(0,0)
	if not hook_shot:
		rope_end = get_global_mouse_position()
	else:
		rope_end = hook_target
	rope_starting_point.global_rotation = (rope_end-global_position).angle()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if not hook_shot and mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if ray.is_colliding():
				if ray.get_collider():	
					hook_shot = true
					hook_target = ray.get_collision_point()
					grappling_rope.ShootRope(hook_target)

#Make the player move towards the rope end and launch him into that direction
func Launch():
	launch = true
	var launch_impulse_dir = (hook_target - global_position).normalized()
	var localTween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	localTween.tween_property(body_to_launch, "position",hook_target, launch_duration)
	localTween.tween_callback(func():
			launch = false
			grappling_rope.HideRope()
			hook_shot = false
			linear_velocity= Vector2(0,0)
			body_to_launch.apply_impulse(launch_impulse_dir*launch_impulse)
			)
