class_name RoomManager
extends Node2D

@export var Rooms : Array[PackedScene]

@export var Textures : Array[Texture2D]

var currentRoom : int = 0
var rng
#@export var EnemiesArray : Array[PackedScene]
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("roomCompleted", roomCompletedFunc)
	
	rng = RandomNumberGenerator.new()
	
	add_child(Rooms[rng.randi_range(0, Rooms.size()-1)].instantiate()) #Random Room
	get_child(0).get_child(0).tile_set.get_source(0).texture = Textures[rng.randi_range(0, Textures.size()-1)] #Random Tileset
	
	pass # Replace with function body.


func roomCompletedFunc():

	#Mover a RoomManager?
	#Transición libro, descargar esta sala, cargar una nueva
	get_tree().root.get_node("SceneManager/TransitionScreen").transition()
	#Transition
	
	
	#Delete Room
	get_child(0).queue_free()
		
	#Add Room
	#var aux = currentRoom
		
	#while aux == currentRoom:
		#aux = rng.randi_range(0, Rooms.size())
		
	#var newRoom : Room
	#newRoom = Rooms[aux].instantiate()
	#add_child(newRoom)		
	
	#Reset State
	pass
