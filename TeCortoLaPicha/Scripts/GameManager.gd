extends Node2D
class_name GameManager
var menu = true

# Called when the node enters the scene tree for the first time.
func _ready():
	#Timer 

	pass # Replace with function body.	

func loadLevel():

	$CurrentScene.get_child(0).queue_free()
	
		
	if get_tree().paused:
		get_tree().paused = false
	
	if menu:
		return
		
	var rng = RandomNumberGenerator.new()
	var level = rng.randi_range(0,1)
		
	if level == 0:

		pass
	elif level == 1:

		pass

func startGame():
	menu = false
	$TransitionScreen.transition()
	pass

func backToMenu():
	menu = true
	$TransitionScreen.transition()
	pass
