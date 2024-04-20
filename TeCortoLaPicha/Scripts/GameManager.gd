extends Node2D
class_name GameManager
var menu = true

@export var GameScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	#Timer 
	Globals.connect("game_start_playing", loadLevel)

func loadLevel():	
	$CurrentScene.add_child(GameScene.instantiate())
		
	if get_tree().paused:
		get_tree().paused = false

func startGame():
	menu = false
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$TransitionScreen.transition()
	pass

func backToMenu():
	menu = true
	$TransitionScreen.transition()
	pass
