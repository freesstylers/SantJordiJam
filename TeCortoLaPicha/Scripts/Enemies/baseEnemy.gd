class_name baseEnemy
extends CharacterBody2D

var Room_: Room = null

func die():
	Room_ = get_parent().get_parent()
	Room_.EnemiesArray.erase(self)
	
	get_parent().remove_child(self)
	self.queue_free()
	
	if Room_.EnemiesArray.size() == 0:
		Globals.roomDepleted.emit()
