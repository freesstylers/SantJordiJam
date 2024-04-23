extends Node

@export var attack : ProgressBar
@export var dash : ProgressBar
@export var hp : AnimationPlayer

var hpState = 8

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
	player.refresh_hp.connect(HPMonitor)
	
	HPReset()
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
	if tweenDash:
		tweenDash.kill()
	dash.value = 0
	pass

func HPReset():
	hp.play("RESET")
	hpState = 9
	pass

func HPMonitor():
	var health = player.characterLife
	var aux = player.timeLimit * ((hpState - 1) / 9.0)
	var aux_up = player.timeLimit * ((hpState) / 9.0)
	
	var up = false
	
	if(health < aux):
		hpState -= 1
	elif(health >= aux_up):
		hpState += 1
		up = true
	else:
		return
	
	
	hp.seek(2, true)
	
	match hpState:
		9:
			if up:
				hp.play("ocho_reset")
			
		8:
			if up:
				hp.play("siete_reset")
			else:
				hp.play("ocho_down")
		7:
			if up:
				hp.play("seis_reset")
			else:
				hp.play("siete_down")
		6:
			if up:
				hp.play("cinco_reset")
			else:
				hp.play("seis_down")
		5:
			if up:
				hp.play("cuatro_reset")
			else:
				hp.play("cinco_down")
			
		4:
			if up:
				hp.play("tres_reset")
			else:
				hp.play("cuatro_down")
			
		3:
			if up:
				hp.play("dos_reset")
			else:
				hp.play("tres_down")
			
		2:
			if up:
				hp.play("uno_reset")
			else:
				hp.play("dos_down")
			
		1:
			if up:
				hp.play("tallo_reset")
			else:
				hp.play("uno_down")
			
		0:
			pass
	pass
