extends Node2D
class_name State

@export var MyState : String = ""

#Wanna do something before executing operate for the first time???
func preState():
	pass

func operate(_delta):
	return MyState

#Wanna do something before going to the next state???
func postState():
	pass
