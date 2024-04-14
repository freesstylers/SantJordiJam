extends Node
class_name DragonVisualizer

@onready var Dragon : Sprite2D = $Dragon

enum ANIM_STATE { IDLE, ATTACK, FALL, DEATH }

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
