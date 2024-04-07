extends RigidBody2D
class_name PlayerHook
@onready var rope_starting_point : Sprite2D = $RopeStartingPoint
@onready var grappling_rope : GrapplingRope = $RopeStartingPoint/Rope
@onready var ray : RayCast2D = $RopeStartingPoint/RayCast2D
@onready var rope_spring : DampedSpringJoint2D = $RopeForceSpring
@onready var image:Sprite2D = $Sprite2D

var hook_shot = false
var hook_target : Vector2 = Vector2.ZERO

func _ready():
	set_can_sleep(false)
	set_process_input(true) # Enable input processing
	
func _process(delta):
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
					rope_spring.node_a = get_path()
					rope_spring.node_b= colliderHit.get_path()
					var distance = hook_target.distance_to(global_position)
					rope_spring.length = 10#hook_target.distance_to(global_position)/4
					rope_spring.rest_length = rope_spring.length*0.75#hook_target.distance_to(global_position)/4
					print(distance,"-",rope_spring.length)
					get_node(get_path()).set_sleeping(false)
					#get_node(colliderHit.get_path()).set_sleeping(false)
					grappling_rope.ShootRope(hook_target)
					
		if hook_shot and mouse_event.button_index == MOUSE_BUTTON_LEFT and not mouse_event.pressed:
			hook_shot = false
			grappling_rope.HideRope()
			rope_spring.node_b = ""
