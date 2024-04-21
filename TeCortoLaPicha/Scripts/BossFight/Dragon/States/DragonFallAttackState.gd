extends DragonStateBase
class_name DragonFallAttackState

@export var AttackSpeed : float = 500
@export var AttackStartingHeight : float = 300
@export var FloorHeight : float = 650

@onready var FallHitSound : AudioStreamPlayer2D = $FallHitSound

var attacking : bool = false
var move_on_x : bool = true
var move_on_y : bool = true
var dist_to_target : float = 30
var vel : Vector2 = Vector2(0,0)
var localTween  = null

func preState():
	attacking=false
	move_on_x = true
	move_on_y = true
	timesAttacked = 0
	vel = Vector2(Dragon.FlyingSpeed,Dragon.FlyingSpeed)
	StateToReturn = MyState
	Dragon.getVisualizer().change_face_player_condition(true)
	Dragon.getVisualizer().start_flying_effect()
	Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.IDLE_FLY)

func postState():
	if localTween != null:
		(localTween as Tween).kill()
		localTween = null

func operate(delta):
	var target = get_pos_to_attack()
	if move_on_y:
		if (abs(Dragon.global_position.y-AttackStartingHeight) > dist_to_target):
			var yMovementDir = get_dir_for_axis(Dragon.global_position.y, AttackStartingHeight)
			Dragon.global_position.y = (Dragon.global_position.y + (yMovementDir*vel.y*delta))
		#Perfect height to attack
		else:
			move_on_y = false
	if move_on_x: 
		var dist = abs(Dragon.global_position.x-target.x)
		if (dist > dist_to_target):
			var xMovementDir = get_dir_for_axis(Dragon.global_position.x, target.x)
			Dragon.global_position.x = (Dragon.global_position.x + (xMovementDir*vel.x*delta))
	#Is the dragon right on top of the player???
	if (Dragon.global_position-target).length()<50 and not move_on_y and not attacking:
		Attack()
		
	return StateToReturn
	
func Attack():
	attacking = true
	Dragon.getVisualizer().stop_flying_effect()
	Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.FALL)
	vel.x = Dragon.FlyingSpeed*3/4
	var attackLength = 1.0
	localTween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	localTween.set_parallel(true)
	localTween.tween_property(self, "vel:x", Dragon.getFlyingSpeed()/4, attackLength*3/4)
	localTween.tween_property(Dragon, "position:y", FloorHeight, attackLength)
	localTween.chain().tween_callback(func():
		Dragon.CamShaker.apply_shake()
		FallHitSound.play()
		move_on_y=true
		attacking = false
		timesAttacked = timesAttacked + 1
		vel.x = Dragon.FlyingSpeed
		if timesAttacked < TimesToAttack:
			Dragon.getVisualizer().start_flying_effect()
			Dragon.getVisualizer().play_animation(DragonVisualizer.ANIM_STATE.IDLE_FLY)
		else:
			StateToReturn = NextState
		localTween = null
		)

func get_pos_to_attack():
	if Dragon.ThePlayer != null:
		return Vector2(Dragon.ThePlayer.global_position.x, AttackStartingHeight)
	return Vector2(get_global_mouse_position().x, AttackStartingHeight)	

func get_dir_for_axis(origin, destity):
	if destity > origin:
		return 1
	else:
		return -1
