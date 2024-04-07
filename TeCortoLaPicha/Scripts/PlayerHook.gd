extends RigidBody2D
class_name PlayerHook
@onready var rope_starting_point : Sprite2D = $RopeStartingPoint
@onready var grappling_rope : GrapplingRope = $RopeStartingPoint/Rope
@onready var ray : RayCast2D = $RopeStartingPoint/RayCast2D
@onready var image:Sprite2D = $Sprite2D

@export var launch : bool = false
@export var launch_impulse_dir : Vector2 = Vector2(0,0)
@export var launch_vel : float = 100
@export var launch_impulse : float = 100

var hook_shot = false
var hook_target : Vector2 = Vector2.ZERO

func _ready():
	set_can_sleep(false)
	set_process_input(true) # Enable input processing
	
func _process(delta):
	if launch:
		return
	if not hook_shot:
		var direction = get_global_mouse_position() - global_position
		rope_starting_point.global_rotation = direction.angle()
		image.global_position = get_global_mouse_position()
	else:
		rope_starting_point.global_rotation = (hook_target-global_position).angle()
		image.global_position = hook_target
	

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if not hook_shot and mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if ray.is_colliding():
				var colliderHit = ray.get_collider()
				if colliderHit:	
					hook_shot = true
					hook_target = ray.get_collision_point()
					grappling_rope.ShootRope(hook_target)
		#if hook_shot and mouse_event.button_index == MOUSE_BUTTON_LEFT and not mouse_event.pressed:
			#hook_shot = false

func Launch():
	launch = true
	launch_impulse_dir = (hook_target - global_position).normalized()
	var localTween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	localTween.tween_property(self, "position",hook_target, 0.35)
	localTween.tween_callback(func():
			launch = false
			grappling_rope.HideRope()
			hook_shot = false
			#DASH?
			)
