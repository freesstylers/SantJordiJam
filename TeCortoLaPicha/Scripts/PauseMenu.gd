extends Control

@export var t : float

var tween : Tween

func TogglePause(state):
	if(state):
		visible = state
		
		TweenIn()
		pass
	else:
		TweenOut()
		pass
		
	pass


func TweenIn():
	if tween:
		tween.kill()
		pass
	
	tween = create_tween()
	tween.tween_property($UI, "rotation_degrees", 0, t).set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property($UI, "global_position", Vector2(0, 0), t).set_trans(Tween.TRANS_LINEAR)
	pass


func TweenOut():
	if tween:
		tween.kill()
		pass
	
	tween = create_tween()
	tween.tween_property($UI, "rotation_degrees", 50, t).as_relative().set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property($UI, "global_position", Vector2(0, -764), t).as_relative().set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(TweenOutEnd)
	pass


func TweenOutEnd():
	visible = false
	pass


func unpause():
	get_tree().root.get_node("SceneManager").TogglePause()
	pass
	
func menu():
	get_tree().root.get_node("SceneManager").backToMenu()
	pass
