extends Node2D

var menu = true

@export var level1 : Resource
@export var level2 : Resource
@export var mainMenu : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	#Globals.connect("loadLevel", loadLevel)

	pass # Replace with function body.	

func loadLevel():

	$CurrentScene.get_child(0).queue_free()
	
		
	if get_tree().paused:
		get_tree().paused = false
	
	if menu:
		$CurrentScene.add_child(mainMenu.instantiate())
		return
		
	var rng = RandomNumberGenerator.new()
	var level = rng.randi_range(0,1)
		
	if level == 0:
		$CurrentScene.add_child(level1.instantiate())
		pass
	elif level == 1:
		$CurrentScene.add_child(level2.instantiate())
		pass

func startGame():
	menu = false
	$TransitionScreen.transition()
	pass

func backToMenu():
	menu = true
	$TransitionScreen.transition()
	pass
