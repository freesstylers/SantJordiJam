class_name Room
extends Node2D

@export var EnemiesArray : Array[baseEnemy]
@export var startingCharacterPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("roomDepleted", roomDepletedFunc)
	connect("roomCompleted", roomCompletedFunc)
	connect("roomStarted", roomStartFunc)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func roomStartFunc():
	#Set position for character
	get_parent().get_parent().get_child(1).position = startingCharacterPosition
	
	#Reset timer
	
	#Reset music?
	pass

func roomDepletedFunc():
	#Desbloquear puerta
	pass
	
func roomCompletedFunc():
	#Mover a RoomManager?
	#Transición libro, descargar esta sala, cargar una nueva
	pass
