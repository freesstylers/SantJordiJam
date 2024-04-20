extends Node
class_name BossFightManager

@export var Dragon : DragonManager = null
@export var ThePlayer : Player = null

@export var DragonDefaultPos : Node2D = null
@export var PlayerDefaultPos : Node2D = null
	
func _ready():
	var localTween = create_tween()
	localTween.tween_callback(
		func():
			scene_to_default()
	).set_delay(2)
	localTween.tween_callback(start_fight).set_delay(2)
	
func scene_to_default():
	#Reset the dragon
	if Dragon != null:
		Dragon.Reset()
		Dragon.global_position = DragonDefaultPos.global_position
	#Reset the player
	if ThePlayer != null:
		ThePlayer.global_position = PlayerDefaultPos.global_position
		
func start_fight():
	Dragon.setState("FIREBALL")	

func PlayerWon():
	pass
	
func PlayerLost():
	pass
