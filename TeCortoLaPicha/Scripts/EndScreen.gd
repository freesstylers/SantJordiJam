extends Node

@export var win : Control
@export var lose : Control
@export var endless : Control
@export var endlessAmt : Label

func Win():
	get_tree().root.get_node("SceneManager").pauseEnabled = false
	get_tree().paused = true
	
	win.visible = true
	pass

func Lose():
	if get_tree().root.get_node("SceneManager").endless:
		Endless()
		pass
	else:
		get_tree().root.get_node("SceneManager").pauseEnabled = false
		get_tree().paused = true
		
		lose.visible = true
	pass

func Endless():
	get_tree().root.get_node("SceneManager").pauseEnabled = false
	get_tree().paused = true
	
	endlessAmt.text = str(get_tree().root.get_node("SceneManager").GameSceneInstance.get_child(0).roomsCompleted)
	endless.visible = true
	pass

func Exit():
	if get_tree() != null and get_tree().root != null:
		get_tree().root.get_child(1).get_child(0).visible = true
		get_tree().root.get_node("SceneManager/ButtonSFX").play()
		get_tree().root.get_node("SceneManager").pauseEnabled = false
		get_tree().paused = true
	
	win.visible = false
	lose.visible = false
	endless.visible = false
	
	get_tree().root.get_node("SceneManager").backToMenu()
	pass
