extends Node

@export var attack : ProgressBar
@export var dash : ProgressBar

@export var roomManager : RoomManager
var player : Player

var tweenAttack : Tween
var tweenDash : Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	attack.value = 0
	dash.value = 0
	pass

func UpdateRoom():
	player = roomManager.currentRoomCont.player
	attack.value = 0
	dash.value = 0
	
	player.attack_start.connect(Attack)
	player.attack_cancel.connect(AttackOver)
	player.dash_start.connect(Dash)
	player.dash_cancel.connect(DashOver)
	pass



func Attack():
	if tweenAttack:
		tweenAttack.kill()
		pass
		
	attack.value = 1
	tweenAttack = create_tween()
	tweenAttack.tween_property(attack, "value", 0, 0.3).set_trans(Tween.TRANS_LINEAR)
	tweenAttack.tween_callback(AttackOver)
	pass

func AttackOver():
	tweenAttack.kill()
	attack.value = 0
	pass

func Dash():
	if tweenDash:
		tweenDash.kill()
		pass
		
	dash.value = 1
	tweenDash = create_tween()
	tweenDash.tween_property(dash, "value", 0, player.dashDuration).set_trans(Tween.TRANS_LINEAR)
	tweenDash.tween_callback(DashOver)
	pass

func DashOver():
	tweenDash.kill()
	dash.value = 0
	pass
