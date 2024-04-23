extends Room
class_name BossFightManager

@export var Dragon : DragonManager = null
#@export var ThePlayer : Player = null

@export var DragonDefaultPos : Node2D = null
@export var PlayerDefaultPos : Node2D = null

@export var BossMusic : AudioStreamPlayer2D
	 
func _ready():
	var localTween = create_tween()
	localTween.tween_callback(
		func():
			scene_to_default()
	).set_delay(1)
	localTween.tween_callback(start_fight).set_delay(2)
	Globals.roomCompleted.connect(PlayerWon)
	
	if get_tree().root.get_child(1).endless == false:
		BossMusic.play()
	
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
	if get_tree().root.get_child(1).endless == true:
		if get_tree().root.get_child(1).get_child(1).get_child_count() > 0:
			get_tree().root.get_child(1).get_child(1).get_child(0).get_child(1).get_child(0).visible = false
		get_tree().root.get_child(1).get_child(0).visible = true
		
		get_tree().root.get_node("SceneManager/TransitionScreen").transition()
		Globals.roomCompleted.disconnect(PlayerWon)
		#Delete Room
		self.queue_free()
		
	else:
		get_tree().root.get_node("SceneManager").EndScreen.Win()
	
func PlayerLost():
	print("DERROTA")
