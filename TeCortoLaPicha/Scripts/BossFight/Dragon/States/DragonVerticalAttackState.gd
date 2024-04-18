extends DragonStateBase
class_name DragonVerticalAttackState

@export var TimesToAttack : int = 1
@export var AttackSpeed : float = 500
@export var AttackMaxHeight : float = 0
@export var FireFlameHitbox : Node2D = null
@export var DelayBeforeFlameStart : float = 2

var preparingAttack : bool = false
var timesAttacked : int = 0

func preState():
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
			attack_player_pos()
	elif timesAttacked >= TimesToAttack:
		return "IDLE"
	return MyState
	
func attack_player_pos():
	var position_to_face = get_pos_to_face_towards()
	var destRot = -45
	if position_to_face.x < Dragon.global_position.x:
		FireFlameHitbox.rotation_degrees = 135
		destRot = 225
	else:
		FireFlameHitbox.rotation_degrees = 45
		destRot = -45
	
	var localTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	var attackLength = 3.0
	localTween.tween_callback(func():
		Dragon.getVisualizer().change_fire_particles_state(true, DelayBeforeFlameStart)
		)
	localTween.tween_property(FireFlameHitbox, "rotation", destRot * PI / 180, attackLength).set_delay(DelayBeforeFlameStart)
	localTween.tween_callback(func():
		Dragon.getVisualizer().change_fire_particles_state(false, 0.5)
		timesAttacked = timesAttacked +1
		if(timesAttacked < TimesToAttack):
			attack_player_pos
		)
	
func get_pos_to_face_towards():
	if Dragon.ThePlayer != null:
		return Dragon.ThePlayer.global_position
	else:
		return get_global_mouse_position()
