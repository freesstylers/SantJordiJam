class_name Room
extends Node2D

@export var EnemiesArray : Array[Node]
@export var startingCharacterPosition: Node2D
@export var player : Player
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("roomDepleted", roomDepletedFunc)
	Globals.connect("roomStarted", roomStartFunc)
	Globals.connect("doorAttempt", doorAttempt)
	
	EnemiesArray = $enemies.get_children() #Set enemies automatically
	
	roomStartFunc()

func roomStartFunc():
	#Set position for character
	player.position = startingCharacterPosition.position
	player.velocity = Vector2(0,0)
	
	#Reset timer
	
	#Reset music?
	pass

func roomDepletedFunc():
	#Desbloquear puerta
	pass
	
func changeWormSprite(tileset):
	for i in range(0, EnemiesArray.size()):
		if EnemiesArray[i] is basic_enemy:
			EnemiesArray[i].changeWormAnim(tileset)
	pass

func doorAttempt():
	if EnemiesArray.size() == 0:
		Globals.roomCompleted.emit()
	else:
		#PlaySound o algo
		pass
	pass
