extends Node2D
class_name DragonVisualizer

@export var flyingFrequency = 1.0
@export var flyingAmplitude = 1.0
@export var flyingPhase = 0.0
@export var FireParticles : CPUParticles2D = null
@export var DragonMngr : DragonManager = null
@export var DeathAnimLength : float = 0.5

@export var DeathSound : AudioStreamPlayer2D = null

@onready var DragonAnimation : Sprite2D = $Dragon

var face_player : bool = true
var flying_effect_active : bool = false
enum ANIM_STATE { IDLE, IDLE_FLY, FIREBALL, FALL, HORIZONTAL, VERTICAL }

func _ready():
	FireParticles.emitting = false

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "fire" or $AnimatedSprite2D.animation == "dash":
		$AnimatedSprite2D.set_animation("flying")
		$AnimatedSprite2D.play()
	elif $AnimatedSprite2D.animation == "fall":
		$AnimatedSprite2D.set_animation("panza")
		$AnimatedSprite2D.play()
	elif $AnimatedSprite2D.animation == "floorfire":
		$AnimatedSprite2D.set_animation("floorfire360")
		$AnimatedSprite2D.play()

func play_animation(new_anim_state : ANIM_STATE):
	match new_anim_state:
		ANIM_STATE.IDLE:
			$AnimatedSprite2D.set_animation("floor")
			#PLAY A LOOP
			pass
		ANIM_STATE.IDLE_FLY:
			$AnimatedSprite2D.set_animation("flying")
			#PLAY A LOOP
			pass
		ANIM_STATE.FIREBALL:
			$AnimatedSprite2D.set_animation("fire")
			#PLAY ONCE, adjust speed to logic
			pass
		ANIM_STATE.FALL:
			$AnimatedSprite2D.set_animation("fall")
			#PLAY ONCE, adjust speed to logic
			pass
		ANIM_STATE.HORIZONTAL:
			$AnimatedSprite2D.set_animation("dash")
			#PLAY ONCE, adjust speed to logic
			pass
		ANIM_STATE.VERTICAL:
			$AnimatedSprite2D.set_animation("floorfire")
			#PLAY ONCE, adjust speed to logic
			pass
	$AnimatedSprite2D.play()

func _process(delta):
	if(face_player):
		var position_to_face = get_pos_to_face_towards()
		if position_to_face.x < DragonMngr.global_position.x:
			$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x)
			#$AnimatedSprite2D.flip_h = false
			#DragonAnimation.scale.x = abs(DragonAnimation.scale.x)
		else:
			$AnimatedSprite2D.scale.x = -abs($AnimatedSprite2D.scale.x)
			#$AnimatedSprite2D.flip_h = true
			#DragonAnimation.scale.x = -abs(DragonAnimation.scale.x)
	
	if not flying_effect_active:
		return 
	flyingPhase += (delta * flyingFrequency)
	var value = sin(flyingPhase) * flyingAmplitude
	DragonAnimation.position.y = value

func stop_flying_effect(duration = 0):
	flying_effect_active = false
	if duration > 0:
		var localTween = create_tween()
		localTween.tween_property(self, "flyingPhase", 0, duration)
	else:
		flyingPhase = 0
		
func start_flying_effect():
	flying_effect_active = true
	
func change_face_player_condition(face):
	face_player = face
	
func change_fire_particles_state(active, duration = 0):
	if active == FireParticles.emitting:
		return 
	FireParticles.emitting = active
	if duration == 0:
		if active:
			FireParticles.scale_amount_min = 3
		else:
			FireParticles.scale_amount_max = 0
	else:
		var localTween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
		if active:
			FireParticles.scale_amount_min = 0
			localTween.tween_property(FireParticles, "scale_amount_min", 3, duration)
		else:
			FireParticles.scale_amount_max = 3
			localTween.tween_property(FireParticles, "scale_amount_max", 0, duration)
		
		
func get_pos_to_face_towards():
	if DragonMngr.ThePlayer != null:
		return DragonMngr.ThePlayer.global_position
	else:
		return get_global_mouse_position()

func PlayTakeDamageEffect():
	var effectDuration : float = 0.25
	var localTween = create_tween()
	localTween.tween_property($AnimatedSprite2D, "modulate", Color.CRIMSON, effectDuration/2)
	localTween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, effectDuration/2)

func DieAnim():
	DeathSound.play()
	FireParticles.visible=false
	var localTween = create_tween()
	localTween.set_parallel(true)
	localTween.tween_property(DragonMngr, "scale", Vector2(0,0), DeathAnimLength)
	localTween.tween_property(DragonMngr, "rotation", 2*PI, DeathAnimLength)
	localTween.chain().tween_callback(
		func():
			DragonMngr.Die()
	)
