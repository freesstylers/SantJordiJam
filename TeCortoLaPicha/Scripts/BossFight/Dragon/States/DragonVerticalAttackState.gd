extends DragonStateBase
class_name DragonVerticalAttackState

@export var AttackSpeed : float = 500
@export var AttackMaxHeight : float = 0
@export var FireFlameHitbox : Node2D = null
@export var DelayBeforeFlameStart : float = 2
@export var DelayBeforeAttack : float = 1
@export var FlameDamage : int = 1

@onready var DelayBeforeAttackTimer : Timer = $DelayBeforeAttack
@onready var FireBeamSound : AudioStreamPlayer2D = $FireBeamSound

var playerHitOnThisAttack : bool = false
var localTween  = null
var thisStateIsActive : bool = false

func preState():
	thisStateIsActive = true
	StateToReturn = MyState
	preparingAttack=true
	playerHitOnThisAttack = false
	timesAttacked = 0
	FireFlameHitbox.rotation_degrees = 45
	Dragon.getVisualizer().start_flying_effect()
	
	Dragon.getVisualizer().change_face_player_condition(true)
	Dragon.getVisualizer().start_flying_effect()
	Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.IDLE_FLY)

func postState():
	thisStateIsActive = false
	if localTween != null:
		(localTween as Tween).kill()
		localTween = null
	DelayBeforeAttackTimer.stop()

func operate(delta):
	if preparingAttack:
		var dir : Vector2 =  (Dragon.VerticalFlameAttackPosition.global_position - Dragon.global_position).normalized()
		Dragon.global_position = Dragon.global_position + (dir*Dragon.getFlyingSpeed()*delta)
		#Reached firing pos
		if (Dragon.global_position - Dragon.VerticalFlameAttackPosition.global_position).length() < 10:
			preparingAttack = false
			DelayBeforeAttackTimer.start(DelayBeforeAttack)
			Dragon.getVisualizer().stop_flying_effect(DelayBeforeAttack)
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
	Dragon.getVisualizer().stop_flying_effect(0.25)
	Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.VERTICAL)
	
	Dragon.getVisualizer().change_fire_particles_state(true, DelayBeforeFlameStart)
	FireBeamSound.play()
	var attackLength = 3.0
	var localTween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	localTween.tween_property(FireFlameHitbox, "rotation", destRot * PI / 180, attackLength).set_delay(DelayBeforeFlameStart)
	localTween.tween_callback(func():
		Dragon.getVisualizer().change_face_player_condition(true)
		Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.IDLE)
		Dragon.getVisualizer().change_fire_particles_state(false, 0.25)
		playerHitOnThisAttack=true #Esto es para evitar que te pegue cuando el fuego ya se apagó
		FireBeamSound.stop()		
		timesAttacked = timesAttacked +1
		if(timesAttacked < TimesToAttack):
			playerHitOnThisAttack=false
			DelayBeforeAttackTimer.start(DelayBeforeAttack)
		else:
			StateToReturn = NextState
		)
	
func get_pos_to_face_towards():
	if Dragon.ThePlayer != null:
		return Dragon.ThePlayer.global_position
	else:
		return get_global_mouse_position()

func other_collided_with_dragon(other):
	if thisStateIsActive and other.is_in_group("player") and not playerHitOnThisAttack and not preparingAttack:
		playerHitOnThisAttack = true
		(other as Player).characterTakeLife(FlameDamage, global_position)
