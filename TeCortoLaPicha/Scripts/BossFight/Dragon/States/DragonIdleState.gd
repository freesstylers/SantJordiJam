extends DragonStateBase
class_name DragonIdleState

@export var timeIdle : float = 2
var timeLeftInIdle : float = timeIdle

func preState():
	#Play IDLE anim 
	timeLeftInIdle = timeIdle

func operate(delta):
	timeLeftInIdle -= delta
	if timeLeftInIdle <= 0:
		return "VERTICAL"
	return MyState
