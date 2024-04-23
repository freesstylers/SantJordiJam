class_name RoomManager
extends Node2D

@export var Rooms : Array[PackedScene]
@export var BossRoom: PackedScene
@export var Textures : Array[Texture2D]
@export var Cantares : Array[String]
@export var Musica : AudioStreamPlayer

var roomsCompleted = 0
var currentRoomCont : Room = null
var roomList : Array[int] = [0,1,2,3,4,5,6,7,8,9]
var rng

signal new_room
#@export var EnemiesArray : Array[PackedScene]
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("roomCompleted", roomCompletedFunc)
	roomsCompleted = 0
	if get_parent().get_parent().get_parent().endless == false:
		var aux = roomList.pick_random()
		roomList.erase(aux)
		currentRoomCont = Rooms[aux].instantiate()
	else:
		rng = RandomNumberGenerator.new()
		var roomIndex = rng.randi_range(0, Rooms.size())
		
		if roomIndex == Rooms.size():
			currentRoomCont = BossRoom.instantiate()
		else:
			currentRoomCont = Rooms[roomIndex].instantiate()

	add_child(currentRoomCont) #Random Room
	
	if Cantares.size() > 0 :
		var aux = Cantares.pick_random()
		Cantares.erase(aux)
		currentRoomCont.player.Cantar(aux)
		pass
	
	var tileset = Textures.pick_random()
	get_child(0).get_child(0).tile_set.get_source(0).texture = tileset #Random Tileset
	
	currentRoomCont.changeWormSprite(tileset)
	new_room.emit()

func roomCompletedFunc():
	#Transition
	if(get_tree() != null && get_tree().root != null):
		if get_tree().root.get_child(1).get_child(1).get_child_count() > 0:
				get_tree().root.get_child(1).get_child(1).get_child(0).get_child(1).get_child(0).visible = false
	
		get_tree().root.get_node("SceneManager/TransitionScreen").transition()
	
	#Delete Room
	get_child(0).queue_free()
		
func addNewRoom():
	if get_parent().get_parent().get_parent().endless == false:
		if roomList.size() < 0:
			var aux = roomList.pick_random()
			roomList.erase(aux)
			currentRoomCont = Rooms[aux].instantiate()
			var tileset = Textures.pick_random()
			currentRoomCont.get_child(0).tile_set.get_source(0).texture = tileset #Random Tileset
		else:
			get_parent().get_child(2).stop()
			get_tree().root.get_child(1).get_child(0).visible = false
			currentRoomCont = BossRoom.instantiate()
			Musica.stop()
		
		add_child(currentRoomCont)
	else:
		roomsCompleted += 1
		
		var roomIndex = rng.randi_range(0, Rooms.size())
		
		if roomIndex == Rooms.size(): 
			get_tree().root.get_child(1).get_child(0).visible = false
			currentRoomCont = BossRoom.instantiate()
		else:
			currentRoomCont = Rooms[roomIndex].instantiate()
			var tileset = Textures.pick_random()
			currentRoomCont.get_child(0).tile_set.get_source(0).texture = tileset #Random Tileset
			currentRoomCont.changeWormSprite(tileset)
	
		add_child(currentRoomCont)
		
	new_room.emit()
