class_name Room
extends Node2D

@export var EnemiesArray : Array[Node]
@export var startingCharacterPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("roomDepleted", roomDepletedFunc)
	Globals.connect("roomStarted", roomStartFunc)
	Globals.connect("doorAttempt", doorAttempt)
	
	EnemiesArray = $enemies.get_children() #Set enemies automatically
	
	roomStartFunc()

func roomStartFunc():
	#Set position for character
	get_parent().get_parent().get_child(1).position = startingCharacterPosition
	get_parent().get_parent().get_child(1).velocity = Vector2(0,0)
	
	#Reset timer
	
	#Reset music?
	pass

func roomDepletedFunc():
	#Desbloquear puerta
	pass

func doorAttempt():
	if EnemiesArray.size() == 0:
		Globals.roomCompleted.emit()
	else:
		#PlaySound o algo
		pass
	pass
