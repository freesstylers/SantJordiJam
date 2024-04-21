extends baseEnemy

@export var DragonMngr : DragonManager  = null
@export var damageToCharacter: int = 1

@onready var DeathSound : AudioStreamPlayer2D = $DeathSound
@onready var DamageOnHitTimer : Timer = $DamageOnHitTimer
@onready var HurtBoxTimer : Timer = $HurtBox/GetHurtTimer

var canDamagePlayer : bool = true
var canGetDamaged : bool = true

func takeDamage(damage):
	life -= damage
	print("DRAGON LIFE:",life)
	if life <= 0:
		die()
	else:
		DragonMngr.getVisualizer().PlayTakeDamageEffect()

func die():
	DragonMngr.setState("")
	DeathSound.play()
	DragonMngr.getVisualizer().DieAnim()

###################DEAL DAMAGE TO THE PLAYER
func other_collided(other):
	if other.is_in_group("player") and canDamagePlayer:
		canDamagePlayer = false
		(other as Player).characterTakeLife(damageToCharacter, global_position)
		DamageOnHitTimer.start()
func damage_timer_finished():
	canDamagePlayer = true

##################GET DAMAGED BY THE PLAYER'S SWORD
func other_area_entered_hurtbox(other):
	if other.is_in_group("sword") and canGetDamaged:
		canGetDamaged = false
		takeDamage(20)
		DragonMngr.getVisualizer().PlayTakeDamageEffect()
		HurtBoxTimer.start()
func hurtbox_timer_finished():
	canGetDamaged = true
