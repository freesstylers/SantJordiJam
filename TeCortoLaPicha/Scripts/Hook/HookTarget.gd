extends Area2D
class_name HookTarget

@export var launch_impulse : float = 400
@onready var hook_target_visualizer : Sprite2D = $Visualizer

func _ready():
	update_target_status(false)

func get_launch_impulse():
	return launch_impulse

func play_anim_or_something():
	pass
func update_target_status(isTarget:bool):
	if(isTarget):
		hook_target_visualizer.modulate = Color.GREEN
	else:
		hook_target_visualizer.modulate = Color.RED
