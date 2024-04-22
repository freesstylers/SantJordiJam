class_name RoomManager
extends Node2D

@export var Rooms : Array[PackedScene]

@export var Textures : Array[Texture2D]

var currentRoom : int = 0
var currentRoomCont : Room = null
var rng
var roomList : Array[int] = [0,1,2,3,4,5,6,7,8,9]

signal new_room
#@export var EnemiesArray : Array[PackedScene]
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("roomCompleted", roomCompletedFunc)
	
	rng = RandomNumberGenerator.new()
	
	var aux = roomList.pick_random()
	roomList.erase(aux)
	
	var room = Rooms[aux].instantiate()
	roomList.append(room)
	currentRoomCont = room
	add_child(room) #Random Room
	
	var tileset = rng.randi_range(0, Textures.size()-1)
	get_child(0).get_child(0).tile_set.get_source(0).texture = Textures[tileset] #Random Tileset
	
	room.changeWormSprite(tileset)
	new_room.emit()
	
	pass # Replace with function body.


func roomCompletedFunc():

	#Mover a RoomManager?
	#Transición libro, descargar esta sala, cargar una nueva
	get_tree().root.get_node("SceneManager/TransitionScreen").transition()
	#Transition
	
	#Delete Room
	get_child(0).queue_free()
		
		
func addNewRoom():
	var aux = roomList.pick_random()
	roomList.erase(aux)
	
	currentRoom = aux
	
	currentRoomCont = Rooms[aux].instantiate()
	add_child(currentRoomCont)
	new_room.emit()
