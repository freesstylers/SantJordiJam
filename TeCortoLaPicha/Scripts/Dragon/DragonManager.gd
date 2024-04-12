extends StateMachine
class_name DragonManager

@export var Lifes : int = 5
var lifesLeft : int = Lifes

func _ready():
	states = {($States/IDLE as State).MyState : ($States/IDLE as State)}

func operate(_delta):
	if currentState == "":
		return
	var nextState = (states.get(currentState) as State).operate()
	if currentState != nextState:
		(states.get(currentState) as State).postState()
		(states.get(nextState) as State).preState()
		currentState = nextState

func setState(new_state : String):
	if currentState != "":
		states.get(currentState).postState()
	if(states.has(new_state)):
		currentState = new_state
		states.get(currentState).preState()
