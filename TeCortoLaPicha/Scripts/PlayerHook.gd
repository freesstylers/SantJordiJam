extends Sprite2D

# Variables to control the hook movement
@export var hook_travel_speed = 400
@export var hook_max_travel_distance = 300

@onready var hook_tip : Node2D = $HookTip
@onready var hook_chain : Node2D = $HookTipChain

var hook_target : Vector2 = Vector2.ZERO
var hook_shot = false

func _ready():
	set_process_input(true) # Enable input processing
	hook_tip.hide()
	hook_chain.hide()
	
func _process(delta):
	if hook_shot:
		var direction = (hook_target - hook_tip.global_position).normalized()
		hook_tip.global_position += direction * hook_travel_speed * delta
		hook_chain.global_position = (hook_tip.global_position + hook_chain.global_position) / 2

		if (hook_tip.global_position - hook_target).length() < 10:
			hook_shot = false
			hook_tip.hide()
			hook_chain.hide()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if not hook_shot and mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			hook_shot = true
			hook_target = get_viewport().get_mouse_position()
			hook_tip.global_position = global_position
			hook_tip.show()
			hook_chain.show()
