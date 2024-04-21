extends DragonStateBase
class_name DragonIdleState

@export var timeIdle : float = 2
var timeLeftInIdle : float = timeIdle

func preState():
	Dragon.getVisualizer().change_face_player_condition(true)
	Dragon.getVisualizer().stop_flying_effect(0.5)
	Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.IDLE)
	#Play IDLE anim 
	timeLeftInIdle = timeIdle

func operate(delta):
	timeLeftInIdle -= delta
	if timeLeftInIdle <= 0:
		return NextState
	return MyState
