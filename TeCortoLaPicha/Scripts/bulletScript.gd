extends CharacterBody2D

@export var launchSpeed = 5000
var shot = false
var Player

func _ready():
	pass
	
func _physics_process(delta):
	position.move_toward(Player.position, 1/launchSpeed)
	pass
