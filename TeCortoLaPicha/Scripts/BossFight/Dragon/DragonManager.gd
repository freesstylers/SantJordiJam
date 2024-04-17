extends StateMachine
class_name DragonManager

@export var Lifes : int = 5
@export var FlyingSpeed : float = 500
@export var FiringPositions : Array[Node2D] = []
@export var VerticalFlameAttackPosition : Node2D = null
@export var HorizontalAttackPosition : Array[Node2D] = []
@export var ThePlayer : Player = null
@onready var Visualizer : DragonVisualizer = $DragonVisualizer

var lifesLeft : int = Lifes

func _ready():
	states = {
		($States/IDLE as State).MyState : $States/IDLE as State,
		($States/FIREBALL_ATTACK_STATE as State).MyState : $States/FIREBALL_ATTACK_STATE as State,
		($States/FALL_ATTACK_STATE as State).MyState : $States/FALL_ATTACK_STATE as State,
		($States/VERTICAL_FLAME_ATTACK_STATE as State).MyState : $States/VERTICAL_FLAME_ATTACK_STATE as State,
		($States/HORIZONTAL_FLAME_ATTACK_STATE as State).MyState : $States/HORIZONTAL_FLAME_ATTACK_STATE as State
		}

func operate(delta):
	if currentState == "":
		return
	print(currentState)
	var nextState = states.get(currentState).operate(delta)
	if currentState != nextState:
		states.get(currentState).postState()
		states.get(nextState).preState()
		currentState = nextState

func setState(new_state : String):
	if currentState != "":
		states.get(currentState).postState()
	if(states.has(new_state)):
		currentState = new_state
		states.get(currentState).preState()

func getVisualizer():
	return Visualizer

func getFiringPositions():
	return FiringPositions

func getFlyingSpeed():
	return FlyingSpeed
