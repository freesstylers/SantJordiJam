extends DragonStateBase
class_name DragonVerticalAttackState

@export var AttackSpeed : float = 500
@export var AttackMaxHeight : float = 0
@export var FireFlameHitbox : Node2D = null
@export var DelayBeforeFlameStart : float = 2

@export var DelayBeforeAttack : float = 1
@onready var DelayBeforeAttackTimer : Timer = $DelayBeforeAttack

func preState():
	StateToReturn = MyState
	preparingAttack=true
	timesAttacked = 0
	FireFlameHitbox.rotation_degrees = 45

func operate(delta):
	if preparingAttack:
		var dir : Vector2 =  (Dragon.VerticalFlameAttackPosition.global_position - Dragon.global_position).normalized()
		Dragon.global_position = Dragon.global_position + (dir*Dragon.getFlyingSpeed()*delta)
		#Reached firing pos
		if (Dragon.global_position - Dragon.VerticalFlameAttackPosition.global_position).length() < 30:
			preparingAttack = false
			DelayBeforeAttackTimer.start(DelayBeforeAttack)
	return StateToReturn
	
func Attack():
	DelayBeforeAttackTimer.stop()
	var position_to_face = get_pos_to_face_towards()
	var destRot = -45
	if position_to_face.x < Dragon.global_position.x:
		FireFlameHitbox.rotation_degrees = 135
		destRot = 225
	else:
		FireFlameHitbox.rotation_degrees = 45
		destRot = -45
	
	#Stop turning and start the particles effect
	Dragon.getVisualizer().change_face_player_condition(false)
	Dragon.getVisualizer().change_fire_particles_state(true, DelayBeforeFlameStart)
	var attackLength = 3.0
	var localTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	localTween.tween_property(FireFlameHitbox, "rotation", destRot * PI / 180, attackLength).set_delay(DelayBeforeFlameStart)
	localTween.tween_callback(func():
		Dragon.getVisualizer().change_face_player_condition(true)
		Dragon.getVisualizer().change_fire_particles_state(false, 0.25)
		timesAttacked = timesAttacked +1
		if(timesAttacked < TimesToAttack):
			DelayBeforeAttackTimer.start(DelayBeforeAttack)
		else:
			StateToReturn = NextState
		)
	
func get_pos_to_face_towards():
	if Dragon.ThePlayer != null:
		return Dragon.ThePlayer.global_position
	else:
		return get_global_mouse_position()
