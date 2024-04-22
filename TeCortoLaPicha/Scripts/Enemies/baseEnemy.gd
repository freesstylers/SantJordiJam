class_name baseEnemy
extends CharacterBody2D

var Room_: Room = null

@export var life : int = 50
@export var damageForceX = 300
@export var damageForceY = 300

@export var particles : PackedScene
var dead = false
var canMoveCD = 0.5
var current_move_buffer = 0

@export var damageSound : AudioStreamPlayer2D

func _process(delta):
	if current_move_buffer <= 0:
		var localTween : Tween = self.create_tween()
		localTween.set_trans(Tween.TRANS_LINEAR)
		localTween.set_ease(Tween.EASE_IN)
		localTween.tween_property(self, "modulate", Color(1.0,1.0,1.0), 0.1)
		localTween.tween_property(self, "modulate", Color.WHITE, 1.0)
	else:
		var localTween : Tween = self.create_tween()
		localTween.set_trans(Tween.TRANS_LINEAR)
		localTween.set_ease(Tween.EASE_IN)
		localTween.tween_property(self, "modulate", Color(1.0,100.0/255.0,100.0/255.0), 0.1)
		localTween.tween_property(self, "modulate", Color.RED, 0.1)
		
func takeDamage(damage):
	life -= damage
	if damageSound != null:
		damageSound.play()
	if particles != null:
		var partAux = particles.instantiate()
		get_parent().add_child((partAux))
		partAux.position = position
		
			
	print(life)
	
	if life <= 0:
		die()

func die():
	dead = true
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
		
func applyForce(player):
	var dir = clamp(position.x - player.x, -1, 1)
	var dirY = clamp(position.y - player.y, -1, 1)
	velocity.x = dir * damageForceX
	velocity.y -=  damageForceY
	current_move_buffer = canMoveCD
	
func applyReducedForce(player):
	var dir = clamp(position.x - player.x, -1, 1)
	var dirY = clamp(position.y - player.y, -1, 1)
	velocity.x = dir * damageForceX/3
	velocity.y -=  damageForceY/3
	current_move_buffer = canMoveCD
	
	
