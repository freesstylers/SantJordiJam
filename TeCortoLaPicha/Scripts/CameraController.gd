extends Node2D

@export var Player : Player
@export var speed = 60

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, Player.position, speed * delta)
	pass
