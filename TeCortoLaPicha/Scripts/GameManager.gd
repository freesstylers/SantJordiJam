extends Node2D
class_name GameManager
var menu = true
var pauseEnabled = false
var firstTimeLangSetup = false

@export var GameScene : PackedScene
@export var MainMenuScene : PackedScene

@export var EndScreen : Control

var GameSceneInstance = null

var endless = false
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

func startGame(endless_):
	menu = false
	pauseEnabled = false
	endless = endless_
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

func Menu():
	$CurrentScene.add_child(MainMenuScene.instantiate())
	GameSceneInstance = null
	pass

