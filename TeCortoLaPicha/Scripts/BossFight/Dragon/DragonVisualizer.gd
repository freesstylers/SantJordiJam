extends Node
class_name DragonVisualizer

@export var flyingFrequency = 1.0
@export var flyingAmplitude = 1.0
@export var flyingPhase = 0.0
@onready var Dragon : Sprite2D = $Dragon

var flying_effect_active : bool = false
enum ANIM_STATE { IDLE, ATTACK, FALL, DEATH }

func update_animation(new_anim_state : ANIM_STATE):
	match new_anim_state:
		ANIM_STATE.IDLE:
			pass
		ANIM_STATE.ATTACK:
			pass
		ANIM_STATE.FALL:
			pass
		ANIM_STATE.DEATH:
			pass

func _process(delta):
	if not flying_effect_active:
		return 
	flyingPhase += (delta * flyingFrequency)
	var value = sin(flyingPhase) * flyingAmplitude
	Dragon.position.y = value

func stop_flying_effect(duration = 0):
	flying_effect_active = false
	if duration > 0:
		var localTween = create_tween()
		localTween.tween_property(self, "flyingPhase", 0, duration)
	else:
		flyingPhase = 0
func start_flying_effect():
	flying_effect_active = true
