extends DragonStateBase
class_name DragonFallAttackState

@export var TimesToFall : int = 3
@export var AttackSpeed : float = 500
@export var AttackStartingHeight : float = 300
@export var FloorHeight : float = 650

var attacking : bool = false
var timesFallen : int = 0
var move_on_x : bool = true
var move_on_y : bool = true
var dist_to_target : float = 30
var vel : Vector2 = Vector2(0,0)

func preState():
	attacking=false
	move_on_x = true
	move_on_y = true
	timesFallen = 0
	vel = Vector2(Dragon.FlyingSpeed,Dragon.FlyingSpeed)

func operate(delta):
	var target = get_pos_to_attack()
	if move_on_y:
		if (abs(Dragon.global_position.y-AttackStartingHeight) > dist_to_target):
			var yMovementDir = get_dir_for_axis(Dragon.global_position.x, AttackStartingHeight)
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
		attack()
	
	if timesFallen >= TimesToFall:
		return "IDLE"
	return MyState
	
func attack():
	attacking = true
	vel.x = Dragon.FlyingSpeed*3/4
	var attackLength = 1.0
	var localTween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	localTween.set_parallel(true)
	localTween.tween_property(self, "vel:x", Dragon.getFlyingSpeed()/2, attackLength*3/4)
	localTween.tween_property(Dragon, "position:y", FloorHeight, attackLength)
	localTween.chain().tween_callback(func():
		move_on_y=true
		attacking = false
		timesFallen = timesFallen + 1
		vel.x = Dragon.FlyingSpeed
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
