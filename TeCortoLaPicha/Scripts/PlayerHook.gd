extends RigidBody2D
class_name PlayerHook
@onready var rope_starting_point : Sprite2D = $RopeStartingPoint
@onready var grappling_rope : GrapplingRope = $RopeStartingPoint/Rope
@onready var ray : RayCast2D = $RopeStartingPoint/RayCast2D
@onready var rope_spring : DampedSpringJoint2D = $RopeForceSpring

var hook_shot = false
var hook_target : Vector2 = Vector2.ZERO

func _ready():
	set_process_input(true) # Enable input processing
	
func _process(delta):
	if not hook_shot:
		var direction = get_global_mouse_position() - global_position
		rope_starting_point.global_rotation = direction.angle()
		

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if not hook_shot and mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if ray.is_colliding():
				var colliderHit = ray.get_collider()
				if colliderHit:	
					hook_shot = true
					hook_target = ray.get_collision_point()
					rope_spring.node_b= colliderHit.get_path()
					rope_spring.rest_length = hook_target.distance_to(global_position)/2
					grappling_rope.ShootRope(hook_target)
					
		if hook_shot and mouse_event.button_index == MOUSE_BUTTON_LEFT and not mouse_event.pressed:
			hook_shot = false
			grappling_rope.HideRope()
			rope_spring.node_b = ""
