extends DragonStateBase
class_name DragonFireballAttackState

@export var FireBallSpeed : float = 500
@export var FireballPrefab : PackedScene = null
@export var delayBeforeFireball : float = 0.5
@export var delayBetweanFireballs : float = 0.1
@export var ShotsPerAttack : int = 1

@onready var DelayBeforeFiringTimer : Timer = $DelayBeforeFiring
@onready var DelayBetweanFireballsTimer : Timer = $DelayBetweanFireballs

var firingPos : Vector2 = Vector2(0,0)
var timesShotThisAttack : int = 0

func preState():
	StateToReturn = MyState
	timesAttacked = 0
	timesShotThisAttack = 0
	preparingAttack = true
	select_firing_pos()
	
func postState():
	DelayBeforeFiringTimer.stop()

func operate(delta):
	if preparingAttack:
		var dir : Vector2 =  (firingPos - Dragon.global_position).normalized()
		Dragon.global_position = Dragon.global_position + (dir*Dragon.getFlyingSpeed()*delta)
		#Reached firing pos
		if (Dragon.global_position - firingPos).length() < 30:
			preparingAttack = false
			DelayBeforeFiringTimer.start(delayBeforeFireball)
	return StateToReturn
	
func select_firing_pos():
	#Set the next firing position if any, if there are no positions available shot from your current pos
	var firingPositions = Dragon.getFiringPositions() as Array[Vector2]
	if firingPositions.size() > 0:
		var new_pos = Dragon.getFiringPositions().pick_random().global_position 
		while new_pos == firingPos:
			new_pos = Dragon.getFiringPositions().pick_random().global_position
		firingPos = new_pos
	else:
		firingPos = Dragon.global_position

func Attack():
	#Instantiate fireball
	var target_dir = (get_pos_to_shoot_fireball() - Dragon.global_position).normalized()
	var instance = FireballPrefab.instantiate()
	instance.global_position = Dragon.global_position
	(instance as Fireball).shoot(target_dir, FireBallSpeed)
	get_parent().get_parent().get_parent().add_child(instance)
	#Reset timers just in case
	DelayBeforeFiringTimer.stop()
	DelayBetweanFireballsTimer.stop()
	#Enough fireballs for this attack?
	timesShotThisAttack = timesShotThisAttack + 1
	if timesShotThisAttack < ShotsPerAttack:
		DelayBetweanFireballsTimer.start(delayBetweanFireballs)
	else:
		timesAttacked = timesAttacked + 1
		timesShotThisAttack = 0
		#Check if the state should continue
		if timesAttacked < TimesToAttack:
			preparingAttack = true
			select_firing_pos()
		else:
			StateToReturn = NextState

func get_pos_to_shoot_fireball():
	return get_global_mouse_position()
