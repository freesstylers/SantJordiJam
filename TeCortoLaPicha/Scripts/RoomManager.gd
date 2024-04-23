class_name RoomManager
extends Node2D

@export var Rooms : Array[PackedScene]
@export var BossRoom: PackedScene
@export var Textures : Array[Texture2D]
@export var Cantares : Array[String]

var currentRoomCont : Room = null
var roomList : Array[int] = [0,1,2,3,4,5,6,7,8,9]

signal new_room
#@export var EnemiesArray : Array[PackedScene]
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("roomCompleted", roomCompletedFunc)
	
	var aux = roomList.pick_random()
	roomList.erase(aux)
	
	var room = Rooms[aux].instantiate()
	currentRoomCont = room
	add_child(room) #Random Room
	
	if Cantares.size() > 0 :
		aux = Cantares.pick_random()
		Cantares.erase(aux)
		room.player.Cantar(aux)
		pass
	
	var tileset = Textures.pick_random()
	get_child(0).get_child(0).tile_set.get_source(0).texture = tileset #Random Tileset
	
	room.changeWormSprite(tileset)
	new_room.emit()

func roomCompletedFunc():
	#Transition
	get_tree().root.get_node("SceneManager/TransitionScreen").transition()
	
	#Delete Room
	get_child(0).queue_free()
		
func addNewRoom():
	if roomList.size() > 0:
		var aux = roomList.pick_random()
		roomList.erase(aux)
		currentRoomCont = Rooms[aux].instantiate()
		add_child(currentRoomCont)
	else:
		currentRoomCont = BossRoom.instantiate()
		add_child(currentRoomCont)
		
	new_room.emit()
