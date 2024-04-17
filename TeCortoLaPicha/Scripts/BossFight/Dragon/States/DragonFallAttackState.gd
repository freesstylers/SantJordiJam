extends DragonStateBase
class_name DragonFallAttackState

@export var TimesToFall : int = 3
@export var AttackSpeed : float = 500
@export var AttackMaxHeight : float = 0

var attackPos : Vector2 = Vector2(0,0)
var preparingAttack : bool = false
var timesFallen : int = 0

func preState():
	preparingAttack=true
	timesFallen = 0

func operate(delta):
	if preparingAttack:
		var target = get_pos_to_attack()
		target.y = AttackMaxHeight+100	
		var dir : Vector2 =  (target - Dragon.global_position).normalized()
		Dragon.global_position = Dragon.global_position + (dir*Dragon.getFlyingSpeed()*delta)
		#Reached firing pos
		if (Dragon.global_position - target).length() < 30:
			preparingAttack = false
			attack_player_pos()
	elif timesFallen >= TimesToFall:
		return "IDLE"
	return MyState
	
func attack_player_pos():
	var localTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	var myPos = Dragon.global_position
	var playerPos = get_pos_to_attack()
	var attackLength = 1.0
	
	var attackMiddlePoint : Vector2 = Vector2(myPos.x + ((playerPos.x-myPos.x)/2), AttackMaxHeight)
	localTween.tween_property(Dragon, "position", attackMiddlePoint, attackLength*3/4)
	localTween.tween_property(Dragon, "position", playerPos, attackLength/4)
	localTween.tween_callback(func():
		timesFallen = timesFallen + 1
		if timesFallen != TimesToFall:
			attack_player_pos()
		)

func get_pos_to_attack():
	if Dragon.ThePlayer != null:
		return Dragon.ThePlayer.global_position
	return get_global_mouse_position()
