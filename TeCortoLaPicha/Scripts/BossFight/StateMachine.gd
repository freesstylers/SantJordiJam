extends Node2D
class_name StateMachine

@export var currentState : String = ""
@export var states : Dictionary = {}

func _process(delta):
	operate(delta)

func operate(delta):
	if currentState == "":
		return
	var nextState = (states.get(currentState) as State).operate(delta)
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
