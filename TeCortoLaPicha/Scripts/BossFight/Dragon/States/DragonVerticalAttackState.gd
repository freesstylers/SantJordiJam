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
		return "FIREBALL"
	return MyState
	
func attack_player_pos():
	var localTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	var attackLength = 3.0
	localTween.tween_property(FireFlameHitbox, "rotation", -45 * PI / 180, attackLength).set_delay(DelayBeforeFlameStart)
	localTween.tween_callback(func():
		timesAttacked = timesAttacked +1
		if(timesAttacked < TimesToAttack):
			attack_player_pos
		)
	
