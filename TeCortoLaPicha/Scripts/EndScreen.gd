extends Node

@export var win : Control
@export var lose : Control
@export var endless : Control

@export var gm : GameManager

func Win():
	gm.pauseEnabled = false
	get_tree().paused = true
	
	win.visible = true
	pass

func Lose():
	if gm.endless:
		Endless()
		pass
	else:
		gm.pauseEnabled = false
		get_tree().paused = true
		
		lose.visible = true
	pass

func Endless():
	gm.pauseEnabled = false
	get_tree().paused = true
	
	endless.visible = true
	pass

func Exit():
	gm.pauseEnabled = false
	get_tree().paused = true
	
	win.visible = false
	lose.visible = false
	endless.visible = false
	
	gm.backToMenu()
	pass
