class_name RoomManager
extends Node2D

@export var Rooms : Array[PackedScene]
var currentRoom : int = 0
var rng
#@export var EnemiesArray : Array[PackedScene]
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("roomCompleted", roomCompletedFunc)
	rng = RandomNumberGenerator.new()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func roomCompletedFunc():

	#Mover a RoomManager?
	#Transición libro, descargar esta sala, cargar una nueva
	
	#Transition
	
	
	#Delete Room
	get_child(0).queue_free()
		
	#Add Room
	var aux = currentRoom
		
	#while aux == currentRoom:
		#aux = rng.randi_range(0, Rooms.size())
		
	var newRoom : Room
	newRoom = Rooms[aux].instantiate()
	add_child(newRoom)		
	
	#Reset State
	pass