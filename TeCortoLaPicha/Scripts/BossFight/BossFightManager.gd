extends Room
class_name BossFightManager

@export var Dragon : DragonManager = null
#@export var ThePlayer : Player = null

@export var DragonDefaultPos : Node2D = null
@export var PlayerDefaultPos : Node2D = null
	
func _ready():
	var localTween = create_tween()
	localTween.tween_callback(
		func():
			scene_to_default()
	).set_delay(1)
	localTween.tween_callback(start_fight).set_delay(2)
	Globals.roomCompleted.connect(PlayerWon)
	
func scene_to_default():
	#Reset the dragon
	if Dragon != null:
		Dragon.Reset()
		Dragon.global_position = DragonDefaultPos.global_position
	#Reset the player
	if player != null:
		player.global_position = PlayerDefaultPos.global_position
		
func start_fight():
	Dragon.setState("FIREBALL")	

func PlayerWon():
	get_tree().root.get_child(1).get_child(0).visible = true
	print("VICTORIA")
	
func PlayerLost():
	print("DERROTA")
