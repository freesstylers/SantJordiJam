extends State
class_name DragonStateBase

@export var Dragon : DragonManager = null
@export var TimesToAttack : int = 3
@export var NextState : String = "IDLE"

var timesAttacked : int = 0
var StateToReturn : String = "IDLE"
