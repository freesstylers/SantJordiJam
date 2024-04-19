extends DragonStateBase
class_name DragonHorizontalAttackState

@export var AttackSpeed : float = 500
@export var DelayBeforeAttack : float = 0.5
@onready var DelayBeforeAttackTimer : Timer = $DelayBeforeAttackTimer

var attackStartingPos : Vector2 = Vector2(0,0)
var attackEndPos : Vector2 = Vector2(0,0)

func preState():
	StateToReturn = MyState
	preparingAttack=true
	timesAttacked = 0
	set_attack_positions()	
	Dragon.getVisualizer().start_flying_effect()

func operate(delta):
	if preparingAttack:
		var dir : Vector2 =  (attackStartingPos - Dragon.global_position).normalized()
		Dragon.global_position = Dragon.global_position + (dir*Dragon.getFlyingSpeed()*delta)
		#Reached firing pos
		if (Dragon.global_position - attackStartingPos).length() < 30:
			preparingAttack = false
			DelayBeforeAttackTimer.start(DelayBeforeAttack)
	return StateToReturn
	
func Attack():
	DelayBeforeAttackTimer.stop()
	Dragon.getVisualizer().change_face_player_condition(false)
	Dragon.getVisualizer().stop_flying_effect(0.25)
	var localTween = create_tween()
	var attackLength = 0.5
	localTween.tween_property(Dragon, "position", attackEndPos, attackLength)
	localTween.tween_property(Dragon, "position", attackEndPos - Vector2(0,200), 0.3)
	localTween.tween_callback(func():
		Dragon.getVisualizer().change_face_player_condition(true)
		Dragon.getVisualizer().start_flying_effect()
		timesAttacked = timesAttacked +1
		if(timesAttacked < TimesToAttack):
			DelayBeforeAttackTimer.start(DelayBeforeAttack)
		else:
			StateToReturn = NextState
		)
	
func set_attack_positions():
	if randi()%2 == 0:
		attackStartingPos = Dragon.HorizontalAttackPosition[0].global_position
		attackEndPos = Dragon.HorizontalAttackPosition[1].global_position
	else:
		attackStartingPos = Dragon.HorizontalAttackPosition[1].global_position
		attackEndPos = Dragon.HorizontalAttackPosition[0].global_position	
