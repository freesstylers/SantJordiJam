extends Node2D
class_name DragonVisualizer

@export var flyingFrequency = 1.0
@export var flyingAmplitude = 1.0
@export var flyingPhase = 0.0
@export var FireParticles : CPUParticles2D = null
@export var DragonMngr : DragonManager = null
@export var DeathAnimLength : float = 0.5

@onready var DragonAnimation : Sprite2D = $Dragon

var face_player : bool = true
var flying_effect_active : bool = false
enum ANIM_STATE { IDLE, ATTACK, FALL, DEATH }

func _ready():
	FireParticles.emitting = false
	FireParticles.scale = Vector2(0,0)
	var localTween = create_tween()
	localTween.tween_callback(PlayTakeDamageEffect).set_delay(2)
	localTween.tween_callback(PlayTakeDamageEffect).set_delay(2)

func update_animation(new_anim_state : ANIM_STATE):
	match new_anim_state:
		ANIM_STATE.IDLE:
			pass
		ANIM_STATE.ATTACK:
			pass
		ANIM_STATE.FALL:
			pass
		ANIM_STATE.DEATH:
			pass

func _process(delta):
	if(face_player):
		var position_to_face = get_pos_to_face_towards()
		if position_to_face.x < DragonMngr.global_position.x:
			DragonAnimation.scale.x = -abs(DragonAnimation.scale.x)
		else:
			DragonAnimation.scale.x = abs(DragonAnimation.scale.x)
	
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
			FireParticles.scale = Vector2(1,1)
		else:
			FireParticles.scale = Vector2(0,0)
	else:
		var localTween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
		if active:
			FireParticles.scale = Vector2(0,0)
			localTween.tween_property(FireParticles, "scale", Vector2(1,1), duration)
		else:
			FireParticles.scale = Vector2(1,1)
			localTween.tween_property(FireParticles, "scale", Vector2(0,0), duration)
		
		
func get_pos_to_face_towards():
	if DragonMngr.ThePlayer != null:
		return DragonMngr.ThePlayer.global_position
	else:
		return get_global_mouse_position()

func PlayTakeDamageEffect():
	var effectDuration : float = 0.25
	var localTween = create_tween()
	localTween.tween_property(DragonAnimation, "modulate", Color.CRIMSON, effectDuration/2)
	localTween.tween_property(DragonAnimation, "modulate", Color.WHITE, effectDuration/2)

func DieAnim():
	var localTween = create_tween()
	localTween.set_parallel(true)
	localTween.tween_property(DragonMngr, "scale", Vector2(0,0), DeathAnimLength)
	localTween.tween_property(DragonMngr, "rotatio", 2*PI, DeathAnimLength)
	localTween.chain().tween_callback(
		func():
			Globals.roomDepleted.emit()
	)
