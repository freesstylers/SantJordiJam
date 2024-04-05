class_name GameManager
extends Node

@export var GameTime : int

var Points = 0
var TotalDead = 0
var Experience = 0
var ExpNextLevel = 0
var Level = 0

var TimeLeft = 0

func NextLevelCalc():
	return (Level * 10) + 5

# Called when the node enters the scene tree for the first time.
func _init():

	#Globals.GameMan = self
	#Globals.exp_gain.connect(expGain)
	ExpNextLevel = NextLevelCalc()
	pass
	
func _ready():
	TimeLeft = GameTime
	pass

func _process(delta):
	TimeLeft -= delta
	if(TimeLeft <= 0):
		#Globals.game_over.emit(false)
		pass
	pass

func expGain(exp : float, points : float):
	Points += points
	Experience += exp
	TotalDead += 1
	if(Experience >= ExpNextLevel):
		Level += 1
		Experience -= ExpNextLevel
		ExpNextLevel = NextLevelCalc()
		#Globals.level_up.emit()
		pass
		
	#Globals.exp_update.emit()
	pass
