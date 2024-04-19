class_name baseEnemy
extends CharacterBody2D

var Room_: Room = null

@export var life : int = 50

func takeDamage(damage):
	life -= damage
	
	print(life)
	
	if life <= 0:
		die()

func die():
	Room_ = get_parent().get_parent()
	
	var animLength : float = 0.5
	var endScale : Vector2 = scale * 0
	var localTween : Tween = create_tween()
		
	#var deltaMovement : Vector2 = (self.global_position- other.global_position).normalized() * 500
	localTween.set_parallel(true)
	#localTween.tween_property(self, "position", global_position + deltaMovement , animLength)
	localTween.tween_property(self, "scale", endScale, animLength)
	localTween.tween_property(self, "rotation", rotation + ((2*PI)*1), animLength)	
	localTween.chain().tween_callback(
		func():
			Room_.EnemiesArray.erase(self)
			queue_free()
	)
	var alphaTween : Tween = create_tween()
	alphaTween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	alphaTween.tween_property(self, "modulate:a", 0, animLength)
		
	if Room_.EnemiesArray.size() == 0:
		Globals.roomDepleted.emit()
