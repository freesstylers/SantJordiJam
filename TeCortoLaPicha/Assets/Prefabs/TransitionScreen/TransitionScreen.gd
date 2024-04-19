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
		$Text/Button.visible = true
		pass
	if anim_name == "fade_to_normal":
		Globals.game_start_playing.emit()
		print("Fading to normal")


func _on_button_pressed():
	$AnimationPlayer.play("fade_to_normal")
	$Text/Button.visible = false
