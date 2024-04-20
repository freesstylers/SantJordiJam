extends baseEnemy

@export var DragonMngr : DragonManager  = null
@export var DeathAnimLength : float = 0.5
@onready var DeathSound : AudioStreamPlayer2D = $DeathSound

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
	var localTween = create_tween()
	localTween.set_parallel(true)
	localTween.tween_property(DragonMngr, "scale", Vector2(0,0), DeathAnimLength)
	localTween.tween_property(DragonMngr, "rotatio", 2*PI, DeathAnimLength)
	localTween.chain().tween_callback(
		func():
			Globals.roomDepleted.emit()
	)
