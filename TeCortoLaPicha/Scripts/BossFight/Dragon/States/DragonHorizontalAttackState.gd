extends DragonStateBase
class_name DragonHorizontalAttackState

@export var TimesToAttack : int = 1
@export var AttackSpeed : float = 500
@export var DelayBeforeAttack : float = 2

var preparingAttack : bool = false
var timesAttacked : int = 0
var attackStartingPos : Vector2 = Vector2(0,0)
var attackEndPos : Vector2 = Vector2(0,0)

func preState():
	preparingAttack=true
	timesAttacked = 0
	if randi()%2 == 0:
		attackStartingPos = Dragon.HorizontalAttackPosition[0].global_position
		attackEndPos = Dragon.HorizontalAttackPosition[1].global_position
	else:
		attackStartingPos = Dragon.HorizontalAttackPosition[1].global_position
		attackEndPos = Dragon.HorizontalAttackPosition[0].global_position		

func operate(delta):
	if preparingAttack:
		var dir : Vector2 =  (attackStartingPos - Dragon.global_position).normalized()
		Dragon.global_position = Dragon.global_position + (dir*Dragon.getFlyingSpeed()*delta)
		#Reached firing pos
		if (Dragon.global_position - attackStartingPos).length() < 30:
			preparingAttack = false
			attack_player_pos()
	elif timesAttacked >= TimesToAttack:
		return "VERTICAL"
	return MyState
	
func attack_player_pos():
	var localTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	var attackLength = 3.0
	localTween.tween_property(Dragon, "position", attackEndPos, attackLength).set_delay(DelayBeforeAttack)
	localTween.tween_callback(func():
		timesAttacked = timesAttacked +1
		if(timesAttacked < TimesToAttack):
			attack_player_pos
		)
	
