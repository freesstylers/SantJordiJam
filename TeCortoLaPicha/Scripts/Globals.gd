extends Node

###################CONSTANTS###################
const WINDOW_BASE_SIZE = Vector2(1280,1280)
var RNG = RandomNumberGenerator.new()
#var ThePlayer : Player = null
var MAX_PLAYER_LIFE : int = 100
var GameMan : GameManager = null



#Gameplay loop
signal game_init_everything()
signal game_start_playing()
signal game_over(playerDead : bool)

signal doorAttempt()
signal roomDepleted()
signal roomCompleted()
signal roomStarted()
