extends DragonStateBase
class_name DragonHorizontalAttackState

@export var DelayBeforeAttack : float = 0.5

@onready var DelayBeforeAttackTimer : Timer = $DelayBeforeAttackTimer
@onready var ThrustSound : AudioStreamPlayer2D = $ThrustSound

var attackStartingPos : Vector2 = Vector2(0,0)
var attackEndPos : Vector2 = Vector2(0,0)
var localTween  = null

func preState():
	StateToReturn = MyState
	preparingAttack=true
	timesAttacked = 0
	set_attack_positions()	
	Dragon.getVisualizer().change_face_player_condition(true)
	Dragon.getVisualizer().start_flying_effect()
	Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.IDLE_FLY)

func postState():
	if localTween != null:
		(localTween as Tween).kill()
		localTween = null
	DelayBeforeAttackTimer.stop()
	
func operate(delta):
	if preparingAttack:
		var dir : Vector2 =  (attackStartingPos - Dragon.global_position).normalized()
		Dragon.global_position = Dragon.global_position + (dir*Dragon.getFlyingSpeed()*delta)
		#Reached firing pos
		if (Dragon.global_position - attackStartingPos).length() < 10:
			preparingAttack = false
			DelayBeforeAttackTimer.start(DelayBeforeAttack)
	return StateToReturn
	
func Attack():
	DelayBeforeAttackTimer.stop()
	
	Dragon.getVisualizer().change_face_player_condition(false)
	Dragon.getVisualizer().stop_flying_effect(0.5)
	Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.HORIZONTAL)
	
	localTween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	var attackLength = 1.25
	ThrustSound.play()
	localTween.tween_property(Dragon, "global_position", attackEndPos, attackLength)
	localTween.tween_callback(
		func():
			Dragon.getVisualizer().change_face_player_condition(true)
			Dragon.getVisualizer().start_flying_effect()
			Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.IDLE_FLY)
			localTween = create_tween()
			localTween.tween_property(Dragon, "global_position", attackEndPos - Vector2(0,200), attackLength)
			localTween.tween_callback(
				func():
					Dragon.getVisualizer().start_flying_effect()
					timesAttacked = timesAttacked +1
					if(timesAttacked < TimesToAttack):
						set_attack_positions()
						preparingAttack = true
					else:
						StateToReturn = NextState
)
)

	
func set_attack_positions():
	if get_player_pos().x > Dragon.global_position.x:
		attackStartingPos = Dragon.HorizontalAttackPosition[0].global_position
		attackEndPos = Dragon.HorizontalAttackPosition[1].global_position
	else:
		attackStartingPos = Dragon.HorizontalAttackPosition[1].global_position
		attackEndPos = Dragon.HorizontalAttackPosition[0].global_position	

func get_player_pos():
	if Dragon.ThePlayer != null:
		return Dragon.ThePlayer.global_position
	return get_global_mouse_position()
