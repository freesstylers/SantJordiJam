extends DragonStateBase
class_name DragonFireballAttackState

@export var TimesToShoot : int = 3
@export var FireBallSpeed : float = 500
@export var FireballPrefab : PackedScene = null

var firingPos : Vector2 = Vector2(0,0)
var movingTowardsFiringPos : bool = false
var firing : bool = false
var timesShot : int = 0

func preState():
	start_moving_towards_firing_pos()
	timesShot = 0

func operate(delta):
	if movingTowardsFiringPos:
		var dir : Vector2 =  (firingPos - Dragon.global_position).normalized()
		Dragon.global_position = Dragon.global_position + (dir*Dragon.getFlyingSpeed()*delta)
		#Reached firing pos
		if (Dragon.global_position - firingPos).length() < 30:
			movingTowardsFiringPos = false
			firing = true
	if firing:
		#Instantiate fireball
		var target_dir = (get_pos_to_shoot_fireball() - Dragon.global_position).normalized()
		var instance = FireballPrefab.instantiate()
		instance.global_position = Dragon.global_position
		(instance as Fireball).shoot(target_dir, FireBallSpeed)
		get_parent().get_parent().get_parent().add_child(instance)
		
		timesShot = timesShot + 1
		if timesShot >= TimesToShoot:
			return "IDLE"
		start_moving_towards_firing_pos()
	
	return MyState

func postState():
	pass
	
func start_moving_towards_firing_pos():
	movingTowardsFiringPos = true
	firing = false
	#Set the next firing position if any, if there are no positions available shot from your current pos
	var firingPositions = Dragon.getFiringPositions() as Array[Vector2]
	if firingPositions.size() > 0:
		var new_pos = Dragon.getFiringPositions().pick_random().global_position 
		while new_pos == firingPos:
			new_pos = Dragon.getFiringPositions().pick_random().global_position
		firingPos = new_pos
	else:
		firingPos = Dragon.global_position

func get_pos_to_shoot_fireball():
	return get_global_mouse_position()
