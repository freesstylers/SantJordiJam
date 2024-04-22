extends CanvasLayer

signal screenTransitioned

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func transition():
	$AnimationPlayer.play("fade_to_black")
	print("Fading to black")

	#$AnimationPlayer.play("fade_to_black")
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		$AnimationPlayer.play("fade_to_normal")
		pass
	if anim_name == "fade_to_normal":
		if get_tree().root.get_child(1).GameSceneInstance == null:
			Globals.game_start_playing.emit()
		else:
			get_tree().root.get_child(1).get_child(1).get_child(0).get_child(0).addNewRoom()
		print("Fading to normal")
