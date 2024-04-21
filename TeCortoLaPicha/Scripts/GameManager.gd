extends Node2D
class_name GameManager
var menu = true
var pauseEnabled = false

@export var GameScene : PackedScene
@export var MainMenuScene : PackedScene

var GameSceneInstance = null
# Called when the node enters the scene tree for the first time.
func _ready():
	#Timer 
	Globals.connect("game_start_playing", loadLevel)


func loadLevel():
	get_tree().paused = false
	
	if not menu:
		if GameSceneInstance == null:
			GameSceneInstance = GameScene.instantiate()
			$CurrentScene.add_child(GameSceneInstance)
		else:
			pass
			
		pauseEnabled = true
	else:
		$CurrentScene.add_child(MainMenuScene.instantiate())
		pauseEnabled = false
		pass
	pass

func startGame():
	menu = false
	pauseEnabled = false
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$TransitionScreen.transition()
	pass

func backToMenu():
	if get_tree().paused:
		TogglePause()
	menu = true
	pauseEnabled = false
	$CurrentScene.remove_child($CurrentScene.get_child(0))
	$TransitionScreen.transition()
	pass


func _input(event):
		
	if pauseEnabled and Input.is_action_just_pressed("Esc"):
		TogglePause()
		pass
	pass

func TogglePause():
	pauseEnabled = false
	get_tree().paused = not get_tree().paused
	$MenuHolder/PauseMenu.TogglePause(get_tree().paused)
	$MenuHolder/PauseMenu.tween.tween_callback(EnablePause)
	pass
	

func EnablePause():
	pauseEnabled = not menu
	pass
